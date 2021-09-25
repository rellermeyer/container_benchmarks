#!/bin/bash

FILE=/etc/docker/daemon.json
if [ -f "$FILE" ]; then
    echo "$FILE already exists, assuming KataContainers has been installed"
else 
    echo "$FILE does not exist. KataContainers might not have been installed. Please do that first"
    exit 1
fi

curl -fsSL https://gvisor.dev/archive.key | sudo apt-key add - && \
sudo add-apt-repository "deb https://storage.googleapis.com/gvisor/releases release main" && \
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common runsc
#runsc automatically adds the runtime option to /etc/docker/daemon.json
sudo systemctl restart docker
