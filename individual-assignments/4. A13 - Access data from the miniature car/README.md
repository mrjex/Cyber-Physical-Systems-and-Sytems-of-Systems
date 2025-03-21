# Assignment 13 - Access data from the miniature car



- https://github.com/chalmers-revere/opendlv-vehicle-view


- h264 repo link here


- OpenCV template repo: https://github.com/chalmers-revere/working-with-rec-files/tree/master/cpp-opencv



- To access the data from other applications (eg., the one we want to write), and especially the video feed from the miniature vehicle, we need to unpack the compressed video frames so that your application can make use of the individual pixels. The video frames in the recording file, however, are stored in the recording file in h264 format (cf. https://www.researchgate.net/publication/4222524_Introduction_to_H264_advanced_video_codingLinks to an external site.) to keep the file sizes small. However, the h264 format must be unpacked first into more suitable pixel layouts such as ARGB (cf. https://en.wikipedia.org/wiki/RGBA_color_modelLinks to an external site.) so that we can access individual pixels in a layout of a two dimensional array.




## Learning goals

In this assignment, I learned how to write a C++ application to access the sensor data from the miniature vehicle. Furthermore, I used OpenCV as a widely used library for image processing (https://opencv.org/)




## Connect to shared memory

- Connect the dockerized microservices to a shared memory area



The call to Docker looks almost similar as the one where we started the h264decoder. The important parameters are highlighted: 

--ipc=host: here, we also allow access to the IPC from the host system so that the two microservices h264decoder and my-opencv-example can "see" each other; must be placed on the left-hand side of the Docker image name
--name=img: this parameter is the name of the shared memory area where the ARGB image can be found; it must match with the name that you specified in the h264decoder microservice (highlighted in green above); must be placed on the right-hand side of the Docker image name
--width=640: width of the ARGB image; must match with the dimensions as identified by the h264decoder; must be placed on the right-hand side of the Docker image name
--height=480: height of the ARGB image; must match with the dimensions as identified by the h264decoder; must be placed on the right-hand side of the Docker image name






## Other description


The two microservices, h264decoder and my-opencv-example, collaborate as producer-consumer as follows:

The h264decoder microservice is the producer for new data and receives a compressed h264 video frame from OpenDLV-Vehicle-View when you start the replay via a network communication. It is extracting the bytes from the network package and tries to decode the h264 frame; as h264 for this recording file is a lossy codec, the first few frames might not get decoded until the decoder has received the first h264 I-frame that marks the start of a new group-of-pictures (GOP). At that moment, it created the shared memory where it places the decoded pixels in ARGB layout.

This copying into the shared memory area works as follows: Firstly, the h264decoder tries to lock the shared memory for exclusive access (similar to a mutexLinks to an external site.); if any other process would hold the exclusive access to the shared memory, the h264decoder is blocked and waits until the access is possible. If the access is possible, the shared memory area is locked and the pixel data is decoded from the raw h264 frame into the shared memory area.

Afterwards, the shared memory area is unlocked and all other processes, which are currently sleeping while waiting for a notification to continue working with new data in the shared memory environment, will receive a notification signal from h264decoder.

Your microservice my-opencv-example is acting as consumer for new data and is usually waiting for new data to arrive. The microservice is attaching to an existing shared memory area, which in our example is created by h264decoder and falls asleep to wait for a notification from h264decoder to continue; this also means that you cannot start your own application before you have started the h264decoder as the shared memory area will only be created once the h264decoder micro service has successfully decoded frames. Once your microservice is receiving this notification, it is waking up, locking the shared memory area and from that moment on, it can do something with the pixel data; in our example, it is creating an OpenCV data structure from the pixel data in the shared memory environment to overlay a red rectangle and display the frame.