# Assignment 14 - Object detection with HSV

## OpenDLV-Vehicle-View

```
sudo docker run --rm -i --init --net=host --name=opendlv-vehicle-view -v $PWD:/opt/vehicle-view/recordings -v /var/run/docker.sock:/var/run/docker.sock -p 8081:8081 chrberger/opendlv-vehicle-view:v0.0.64
```


## H264 Microservice

```
xhost +

sudo docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp h264decoder:v0.0.5 --cid=253 --name=img
```


## OpenCV Microservice

```
sudo docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp my-opencv-example:latest --cid=253 --name=img --width=640 --height=480 --verbose
```

To test the new code, rebuild the docker image:

```
sudo docker build -f Dockerfile -t my-opencv-example .
```


# HSV Color Space Microservice

```
sudo docker run --rm -ti --init --ipc=host -v /tmp:/tmp -e DISPLAY=$DISPLAY hsv:latest --name=img --width=640 --height=480
```