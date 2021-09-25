#!/bin/bash

../../base/clean_instances.sh

mkdir ../../results/ffmpeg
docker build -t ffmpeg-bench .

for RUNTIME in runc runsc kata-runtime; do 
    docker run -it --runtime=$RUNTIME --memory=32768M --cpus=16 --name ffmpeg-bench ffmpeg-bench
    docker cp ffmpeg-bench:/result ../../results/ffmpeg/$RUNTIME
    docker rm ffmpeg-bench
done