# TODOs (COMPLETE BEFORE 18:50)
# 1) Delete docker images
# 2) A5 build normal img, Build slim img, Build manually small img from this Dockerfile
# 3) Generate ollama conversation + pictures
# 4) Find resources
# 5) SUBMIT


# Joel Mattsson, A5 - Bonus, joelmat, 1,1MB

# NOTE:
# The commands below, and other similar commands in this file are "merged" together into one command
# to reduce the number of layers, and in turn, elevate the space-efficiency of the produced docker container

##################################################
# Section 1: Build the application

FROM alpine:latest AS builder

RUN apk update && \
        apk upgrade

ADD . /opt/sources
WORKDIR /opt/sources

# Install the necessary dependencies/packages to correctly build the container
RUN apk add cmake make g++ libstdc++ libgcc

# Below we --> static link, strip binaries in the "tmp" folder
# In the command below, I first statically link my binary with cmake, copy
# "helloworld" into the temporary "tmp" folder, and lastly I strip it
RUN cd /opt/sources && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-static" .. && \
    make && make test && cp helloworld /tmp && \
    cd /tmp && strip helloworld



##################################################
# Section 2: Bundle the application.

# BASE-IMAGE SELECTION RATIONALE:
# In this stage, we tell the compiler that we will build it from scratch, meaning that
# no pre-built packages or filesystems are taking up any space. Considering that only
# three basic commands are used below (folder navigation, copying content and program
# entrypoint), it would be a waste of space to built it from a base image that provides
# additional libraries. Conversely, in the first stage where we utilize cmake, g++ and libs,
# it is a must to accommodate additional space for these functionalties.
FROM scratch

WORKDIR /opt
COPY --from=builder /tmp/helloworld .

ENTRYPOINT ["/opt/helloworld"]