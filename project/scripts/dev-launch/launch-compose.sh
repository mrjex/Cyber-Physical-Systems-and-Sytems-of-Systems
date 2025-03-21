# This script does 2 things:
#   1) Build the images that are excuted as contianers in the compose file
#   2) Run the containers simultaneously


#####   DEFINE IMAGES #####

# Build decoder image
docker build https://github.com/chalmers-revere/opendlv-video-h264-decoder.git#v0.0.5 -f Dockerfile -t h264decoder:v0.0.5

# Pull specified version of group-14 image from docker registry
RELEASE_VERSION="v2.2.0"

docker login registry.git.chalmers.se/courses/dit638/students/2024-group-14
docker pull registry.git.chalmers.se/courses/dit638/students/2024-group-14:${RELEASE_VERSION}


##### RUN CONTAINERS #####

# Note: 'group14' service needs to connect to the OD4-session through the
#       shared memory in advance to be launched correctly. This is done by
#       opening the front-end browser of on the port of 'open-vehicle-view'
#       and navigating to /recordings and play a .rec file

RELEASE_VERSION="v2.2.0" docker compose up