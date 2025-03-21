# TODO:
#
#   - All .sh scripts in the child directories import this script as a module and its general functionality:
#       - gnome terminals to start opendlv-frontend, h264-decoder and OPENCV-EXPERIMENT
#       - gnome terminals to start opendlv-frontend, h264-decoder and VIDEO-HSV-INSPECTOR
#
#       - Idea: make if-else statement in general function checking passed arguments, double check my gnome terminal implementation on GitLab-group-14 project in "/scripts"





# Install gnome terminal dependency
installGnome() {
    sudo apt install -y gnome-terminal
}


#####   RUN AUTONOMOUS TERMINALS   #####


launchContainers() {
    # Open new terminal and run open-vehicle-view
    sudo gnome-terminal -- bash -c "sudo docker run --rm -i --init --net=host --name=opendlv-vehicle-view -v $PWD:/opt/vehicle-view/recordings -v /var/run/docker.sock:/var/run/docker.sock -p 8081:8081 chrberger/opendlv-vehicle-view:v0.0.64; exec bash"

    # Run h264-decoder indepedently
    sudo gnome-terminal -- bash -c "sudo docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp h264decoder:v0.0.5 --cid=253 --name=img; exec bash"



    # TODO:
    #   - If check: ARG 1 == OPENCV-EXPERIMENT or VIDEO-HSV-INSPECTOR
    #   - Invoke this function from the children directories' solution.sh scripts



    # Run group-14's application. Note that the shared memory must be connected through the playback of a .rec file in open-vehicle-view
    sudo gnome-terminal -- bash -c "sudo docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp:/tmp registry.git.chalmers.se/courses/dit638/students/2024-group-14:v2.2.0 --cid=253 --name=img --width=640 --height=480; exec bash"
}






installGnome