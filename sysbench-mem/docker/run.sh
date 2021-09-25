#!/bin/bash
../../base/clean_instances.sh

docker build -t sysbench-ram-docker .
mkdir -p ../../results/sysbenchmem

for RUNTIME in runc runsc kata-runtime; do 
    docker run -it --rm --runtime=$RUNTIME --memory=32768M --cpus=16 --name sysbench-ram-docker sysbench-ram-docker > ../../results/sysbenchmem/$RUNTIME 
    docker stop sysbench-ram-docker
done