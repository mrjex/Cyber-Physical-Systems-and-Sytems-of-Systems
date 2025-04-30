


buildVideoInspectorHSV() {
    docker build -t hsv:latest -f Dockerfile.amd64 https://github.com/chalmers-revere/opendlv-video-hsv-inspector.git
}


buildVideoInspectorHSV



# Open in new terminal:
docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp h264decoder:v0.0.5 --cid=253 --name=img


# Open in new terminal:
docker run --rm --init --net=host --name=opendlv-vehicle-view -v $PWD:/opt/vehicle-view/recordings -v /var/run/docker.sock:/var/run/docker.sock -p 8081:8081 chrberger/opendlv-vehicle-view:v0.0.64


# Finally, you start the colorspace experimentation microservice in a new terminal:
docker run --rm -ti --init --ipc=host -v /tmp:/tmp -e DISPLAY=$DISPLAY hsv:latest --name=img --width=640 --height=480