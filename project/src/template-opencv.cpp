/*
 * Copyright (C) 2020  Christian Berger
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Include the single-file, header-only middleware libcluon to create high-performance microservices
#include "cluon-complete.hpp"
// Include the OpenDLV Standard Message Set that contains messages that are usually exchanged for automotive or robotic applications
#include "opendlv-standard-message-set.hpp"

// Include the GUI and image processing header files from OpenCV
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <stdarg.h>

#define GREEN cv::Scalar(0, 255, 0)

// directions
#define CLOCKWISE -1
#define COUNTER_CLOCKWISE 1

enum class CONE
{
    YELLOW = 0,
    BLUE = 1
};

using namespace std;

cv::Point *analyzeContours(cv::Mat img, vector<vector<cv::Point>> contours);

string currentTimeStamp = "0";
string csvOutputFile;

bool isCone(cv::Rect rect)
{
    return rect.height > rect.width * 1.2 && rect.area() > 200 && rect.area() < 6000;
}

pair<cv::Mat, cv::Mat> hsvDetectionAndFilter(cv::Mat img)
{
    // blue HSV values
    //  H min: 110 H max: 130
    //  S min: 95 S max: 250
    //  V min: 30 V max: 120

    // yellow HSV values
    //  H min: 14 H max: 22
    //  S min: 66 S max: 208
    //  V min: 109 V max: 255
    const cv::Scalar BLACK(0, 0, 0);

    cv::Mat imgHSV;

    cv::GaussianBlur(img, imgHSV, cv::Size(7, 7), 0);
    cv::cvtColor(imgHSV, imgHSV, cv::COLOR_BGR2HSV);

    cv::Point p1(150, 400);
    cv::Point p2(img.size().width / 2 + 185, 480);

    // mask the car
    cv::rectangle(imgHSV, p1, p2, BLACK, cv::FILLED);

    cv::Mat Kernel = cv::Mat(cv::Size(7, 7), CV_8UC1, cv::Scalar(255));

    // mask the top half of the frame
    cv::Rect topMask(0, 0, 640, 270);

    cv::Mat blueCones;
    cv::Mat yellowCones;

    // blue
    cv::inRange(imgHSV, cv::Scalar(110, 95, 30), cv::Scalar(130, 250, 120), blueCones);
    cv::rectangle(blueCones, topMask, BLACK, cv::FILLED);
    cv::morphologyEx(blueCones, blueCones, cv::MORPH_CLOSE, Kernel);

    // yellow
    cv::inRange(imgHSV, cv::Scalar(14, 66, 109), cv::Scalar(22, 208, 255), yellowCones);
    cv::rectangle(yellowCones, topMask, BLACK, cv::FILLED);
    cv::morphologyEx(yellowCones, yellowCones, cv::MORPH_CLOSE, Kernel);

    return make_pair(blueCones, yellowCones);
}

pair<cv::Point *, cv::Point *> findCones(cv::Mat img, cv::Mat blueCones, cv::Mat yellowCones)
{

    vector<vector<cv::Point>> bContours;
    vector<vector<cv::Point>> yContours;

    cv::findContours(blueCones, bContours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    cv::findContours(yellowCones, yContours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    cv::Point *blueCone = analyzeContours(img, bContours);
    cv::Point *yellowCone = analyzeContours(img, yContours);
    return make_pair(blueCone, yellowCone);
}

cv::Point *analyzeContours(cv::Mat img, vector<vector<cv::Point>> contours)
{

    if (contours.size() <= 0)
        return NULL; // if there are no detected objects return -1 as the angle

    vector<cv::Rect> cones;

    for (uint i = 0; i < contours.size(); i++)
    {
        cv::Rect rect = cv::boundingRect(contours[i]);

        if (isCone(rect))
        {
            cones.push_back(rect);
        }
    }

    if (cones.size() < 1)
        return NULL; // no cones in the frame

    cv::Rect closestCone = cones[0];

    for (uint i = 0; i < cones.size(); i++)
    {
        if (cones[i].area() > closestCone.area())
        {
            closestCone = cones[i];
        }
    }

    // draw the closest rectangle
    cv::rectangle(img, closestCone, GREEN, 2);

    int carX = img.size().width / 2;
    int carY = img.size().height - 100;

    // the center point of the cone
    int coneX = closestCone.x + (closestCone.width / 2);
    int coneY = closestCone.y + (closestCone.height / 2);

    cv::line(img, cv::Point(coneX, coneY), cv::Point(carX, carY), GREEN);
    cv::line(img, cv::Point(coneX, carY), cv::Point(carX, carY), GREEN);

    return new cv::Point(coneX, coneY);
}

// get the midpoint between two points
cv::Point getMidPoint(cv::Point *p1, cv::Point *p2)
{
    return cv::Point((p1->x + p2->x) / 2, (p1->y + p2->y) / 2);
}

int getDirection(cv::Mat img, CONE *leftCone, cv::Point *blueCone, cv::Point *yellowCone)
{

    bool noneDetected = yellowCone == NULL && blueCone == NULL;
    bool bothDetected = yellowCone != NULL && blueCone != NULL;

    if (noneDetected)
    {
        throw -1;
    }

    if (bothDetected)
    {
        cv::Point midPt = getMidPoint(blueCone, yellowCone);
        int carX = img.size().width / 2;
        int direction = midPt.x - carX >= 0 ? -1 : 1;

        if (blueCone->x > yellowCone->x)
        {
            *leftCone = CONE::YELLOW;
        }
        else
        {
            *leftCone = CONE::BLUE;
        }

        return direction;
    }

    else
    {

        bool blueOnly = blueCone != NULL && yellowCone == NULL;
        // bool yellowOnly = yellowCone != NULL && blueCone == NULL;

        if (blueOnly) // blue cone turn
        {
            if (*leftCone == CONE::BLUE)
            {
                return CLOCKWISE;
            }
            else
            {
                return COUNTER_CLOCKWISE;
            }
        }

        else // yellow cone turn
        {
            if (*leftCone == CONE::YELLOW)
            {
                return CLOCKWISE;
            }
            else
            {
                return COUNTER_CLOCKWISE;
            }
        }
    }
}

// return a gsr based on the distance and velocity readings provided by the car
double calculateAngle(double velocity, double distanceFromCone, int direction)
{
    double value = (abs(velocity) * 0.002) + (1 / (abs(distanceFromCone) * 10));

    if (value > 0.3)
    {
        value = 0.3;
    }

    return value * direction;
}

void debugResult(double actual, double predicted)
{

    static int tooLow, tooHigh, pass, fail = 0;

    if (actual == 0.0)
        return;

    double threshold = abs(actual) * 0.25;

    if (predicted >= (actual - threshold) && predicted <= (actual + threshold))
    {
        cout << "\033[1;32mComputed angle is within threshold"
             << "\033[0m\n"
             << endl;
        pass++;
    }

    else
    {
        if (predicted > actual)
        {
            tooHigh++;
        }
        else
        {
            tooLow++;
        }
        cout << (predicted > actual ? "Too high: " : "Too low: ");
        cout << "\033[1;31mComputed angle is off by: " << abs(threshold - abs(predicted)) << "\033[0m\n"
             << endl;
        fail++;
    }

    cout << "\033]0;Pass: " << pass << " Fail: " << fail << " Pass Percentage: " << (pass * 1.0 / (pass + fail)) * 100 << "%"
         << " Too high " << tooHigh << " Too low " << tooLow << "\007";
}

void addToCSV(double truth, double angle)
{
    fstream fout;
    fout.open(csvOutputFile, ios::out | ios::app); // NOTE: Assuming that you are running run.sh from parent directory

    // TEMPORARY QUICK FIX
    fout << currentTimeStamp << ";";
    fout << truth << ";";
    fout << angle << ";" << "\n";
}

void initCsvHeaders()
{
    std::fstream fout;
    fout.open(csvOutputFile, std::ios::out | std::ios::app); // NOTE: Assuming that you are running run.sh from parent directory
    fout << "sent.microseconds" << ";"
         << "correctGs" << ";"
         << "calculatedGs" << ";"
         << "\n";
}

int32_t main(int32_t argc, char **argv)
{
    int32_t retCode{1};
    // Parse the command line parameters as we require the user to specify some mandatory information on startup.
    auto commandlineArguments = cluon::getCommandlineArguments(argc, argv);
    if ((0 == commandlineArguments.count("cid")) ||
        (0 == commandlineArguments.count("name")) ||
        (0 == commandlineArguments.count("width")) ||
        (0 == commandlineArguments.count("height")))

    {
        std::cerr << argv[0] << " attaches to a shared memory area containing an ARGB image." << std::endl;
        std::cerr << "Usage:   " << argv[0] << " --cid=<OD4 session> --name=<name of shared memory area> [--verbose]" << std::endl;
        std::cerr << "         --cid:    CID of the OD4Session to send and receive messages" << std::endl;
        std::cerr << "         --name:   name of the shared memory area to attach" << std::endl;
        std::cerr << "         --width:  width of the frame" << std::endl;
        std::cerr << "         --height: height of the frame" << std::endl;
        std::cerr << "Example: " << argv[0] << " --cid=253 --name=img --width=640 --height=480 --verbose" << std::endl;
    }
    else
    {
        // Extract the values from the command line parameters
        const std::string NAME{commandlineArguments["name"]};
        const uint32_t WIDTH{static_cast<uint32_t>(std::stoi(commandlineArguments["width"]))};
        const uint32_t HEIGHT{static_cast<uint32_t>(std::stoi(commandlineArguments["height"]))};

        csvOutputFile = "/Generated_CSV/video" + string(argv[5]) + ".csv";
        // cout << "video number: " << argv[5];

        const bool VERBOSE{commandlineArguments.count("verbose") != 0};

        initCsvHeaders();

        // Attach to the shared memory.
        std::unique_ptr<cluon::SharedMemory> sharedMemory{new cluon::SharedMemory{NAME}};
        if (sharedMemory && sharedMemory->valid())
        {
            std::clog << argv[0] << ": Attached to shared memory '" << sharedMemory->name() << " (" << sharedMemory->size() << " bytes)." << std::endl;

            // Interface to a running OpenDaVINCI session where network messages are exchanged.
            // The instance od4 allows you to send and receive messages.
            cluon::OD4Session od4{static_cast<uint16_t>(std::stoi(commandlineArguments["cid"]))};

            opendlv::proxy::GroundSteeringRequest gsr;
            std::mutex gsrMutex;
            auto onGroundSteeringRequest = [&gsr, &gsrMutex](cluon::data::Envelope &&env)
            {
                // The envelope data structure provide further details, such as sampleTimePoint as shown in this test case:
                // https://github.com/chrberger/libcluon/blob/master/libcluon/testsuites/TestEnvelopeConverter.cpp#L31-L40
                std::lock_guard<std::mutex> lck(gsrMutex);
                gsr = cluon::extractMessage<opendlv::proxy::GroundSteeringRequest>(std::move(env));
            };

            // ========= READ VELOCITY
            opendlv::proxy::AngularVelocityReading vr;
            std::mutex vMutex;

            auto onVelocityRequest = [&vr, &vMutex](cluon::data::Envelope &&env)
            {
                // The envelope data structure provide further details, such as sampleTimePoint as shown in this test case:
                // https://github.com/chrberger/libcluon/blob/master/libcluon/testsuites/TestEnvelopeConverter.cpp#L31-L40
                std::lock_guard<std::mutex> lck(vMutex);
                vr = cluon::extractMessage<opendlv::proxy::AngularVelocityReading>(std::move(env));
            };

            // ========= READ INFRARED SENSOR
            opendlv::proxy::DistanceReading dr;
            std::mutex drMutex;

            auto onDistanceReading = [&dr, &drMutex](cluon::data::Envelope &&env)
            {
                // The envelope data structure provide further details, such as sampleTimePoint as shown in this test case:
                // https://github.com/chrberger/libcluon/blob/master/libcluon/testsuites/TestEnvelopeConverter.cpp#L31-L40
                std::lock_guard<std::mutex> lck(drMutex);
                dr = cluon::extractMessage<opendlv::proxy::DistanceReading>(std::move(env));
            };

            od4.dataTrigger(opendlv::proxy::GroundSteeringRequest::ID(), onGroundSteeringRequest);
            od4.dataTrigger(opendlv::proxy::AngularVelocityReading::ID(), onVelocityRequest);
            od4.dataTrigger(opendlv::proxy::DistanceReading::ID(), onDistanceReading);
            od4.dataTrigger(opendlv::proxy::GroundSteeringRequest::ID(), onGroundSteeringRequest);

            double angle = 0;
            int direction = CLOCKWISE;

            CONE *leftCone = new CONE(CONE::BLUE);

            // Endless loop; end the program by pressing Ctrl-C.
            while (od4.isRunning())
            {
                // OpenCV data structure to hold an image.
                cv::Mat img;

                // Wait for a notification of a new frame.
                sharedMemory->wait();

                // Lock the shared memory.
                sharedMemory->lock();
                {
                    // Copy the pixels from the shared memory into our own data structure.
                    cv::Mat wrapped(HEIGHT, WIDTH, CV_8UC4, sharedMemory->data());
                    img = wrapped.clone();
                }

                pair<bool, cluon::data::TimeStamp> output = sharedMemory->getTimeStamp();
                currentTimeStamp = to_string(cluon::time::toMicroseconds(output.second));

                sharedMemory->unlock();

                // filter the image by hsv and return a pair of frames split by hsv values
                pair<cv::Mat, cv::Mat> frames = hsvDetectionAndFilter(img);

                // find the contours in both frames and return a pointer to a cone on each side
                pair<cv::Point *, cv::Point *> cones = findCones(img, frames.first, frames.second);

                // Lock the mutex so that the data is consistent
                lock_guard<mutex> lck1(gsrMutex);
                lock_guard<mutex> lck2(vMutex);
                lock_guard<mutex> lck3(drMutex);

                // Read the necessary values
                double truth = gsr.groundSteering();
                double velocity = vr.angularVelocityZ();
                double distanceFromCone = dr.distance();

                std::cout << "group_14;" << currentTimeStamp << ";" << angle << std::endl;

                try
                {
                    direction = getDirection(img, leftCone, cones.first, cones.second);
                }

                catch (int err)
                {
                    cout << "No cones detected, falling back to previous direction" << endl;
                }

                angle = calculateAngle(velocity, distanceFromCone, direction);
                std::cout << "group_14;" << currentTimeStamp << ";" << angle << std::endl;

                // Add data to csv
                addToCSV(truth, angle);
                // Display image on your screen.
                if (VERBOSE)
                {
                    // debugResult(truth, angle);
                    cv::imshow(sharedMemory->name().c_str(), img);
                    cv::waitKey(1);
                }
            }
        }
        retCode = 0;
    }
    return retCode;
}