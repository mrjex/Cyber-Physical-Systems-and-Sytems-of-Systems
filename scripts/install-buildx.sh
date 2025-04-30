# Install buildx to simply the docker multi-platform build:

# Folder navigation
mkdir -p ~/.docker/cli-plugins
cd ~/.docker/cli-plugins/

# Install buildx
wget https://github.com/docker/buildx/releases/download/v0.14.0/buildx-v0.14.0.darwin-amd64
# wget https://github.com/docker/buildx/releases/tag/v0.14.0
# wget https://github.com/docker/buildx/releases/download/v0.7.1/buildx-v0.7.1.linux-amd64

# Grant permission in the Operating System for modifications

mv buildx-v0.14.0.darwin-amd64 docker-buildx
# mv buildx-v0.7.1.linux-amd64 docker-buildx

chmod 755 docker-buildx