runApp() {
    docker run --rm -i --init --name=opendlv-vehicle-view -v $PWD:/opt/vehicle-view/recordings -v /var/run/docker.sock:/var/run/docker.sock -p 8081:8081 chrberger/opendlv-vehicle-view:v0.0.64
}


runh264Decoder() {
    docker build https://github.com/chalmers-revere/opendlv-video-h264-decoder.git#v0.0.5 -f Dockerfile -t h264decoder:v0.0.5

    xhost +

    docker run --rm -ti --net=host -e DISPLAY=$DISPLAY -v /tmp:/tmp h264decoder:v0.0.5 --cid=253 --name=img --verbose
}


setupMicroserviceOpenCV() {
    git clone https://github.com/chalmers-revere/working-with-rec-files.git

    cd cpp-opencv
    docker build -f Dockerfile -t my-opencv-example .
}



# we need to tell Docker to allow access to the shared memory area between the h264decoder microservice
# and your application my-opencv-example; thus, you need to start the h264decoder as follows:
connectMicroservicesToSharedMemory() {
    docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp h264decoder:v0.0.5 --cid=253 --name=img
    docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp my-opencv-example:latest --cid=253 --name=img --width=640 --height=480 --verbose 
}



# STEP 1: Run the application as a docker container
runApp



# STEP2: Decompressing the Video Frames:
runh264Decoder



# STEP 3: Accessing the Video Frames
setupMicroserviceOpenCV