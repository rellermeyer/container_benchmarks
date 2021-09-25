#!/bin/bash

docker stop stream-docker
docker rm stream-docker

docker build -t stream-docker .
mkdir -p ../../results/STREAM/

for RUNTIME in runc runsc kata-runtime; do 
    docker run -it --runtime=$RUNTIME --memory=32768M --cpus=16 --name stream-docker stream-docker
    docker cp stream-docker:/result ../../results/STREAM/$RUNTIME

    docker stop stream-docker
    docker rm stream-docker
done
