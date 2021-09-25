#!/bin/bash
../../base/clean_instances.sh

docker build -t tinymembench-docker .
mkdir -p ../../results/tinymembench

for RUNTIME in runsc; do # runsc kata-runtime; do 
    docker run -it --rm --runtime=$RUNTIME --memory=32768M --cpus=16 --name tinymembench-docker tinymembench-docker >> ../../results/tinymembench/$RUNTIME 
    docker stop tinymembench-docker
    sleep 3
done
