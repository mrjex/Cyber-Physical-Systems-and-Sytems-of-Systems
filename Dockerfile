FROM public.ecr.aws/docker/library/alpine:latest as builder

RUN apk add --no-cache cmake g++ make opencv-dev

ADD . /opt/sources
WORKDIR /opt/sources

RUN mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/tmp .. && \
    make && make install && make test

FROM public.ecr.aws/docker/library/alpine:latest
RUN apk add opencv

WORKDIR /usr/bin
COPY --from=builder /tmp/bin/template-opencv .
# This is the entrypoint when starting the Docker container; hence, this Docker image is automatically starting our software on its creation
ENTRYPOINT ["/usr/bin/template-opencv"]
