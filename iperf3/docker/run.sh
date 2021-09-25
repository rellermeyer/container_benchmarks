#!/bin/bash

docker build -t iperf3-docker .
docker stop iperf3-docker

../../base/clean_instances.sh
. ../bench_base.sh

for RUNTIME in runc runsc kata-runtime; do 
   docker run --runtime=$RUNTIME -d --memory=32768M --cpus=16 --rm --name iperf3-docker -p5201:5201 iperf3-docker
   sleep 5

   bench_iperf localhost $(echo $RUNTIME)

   docker stop iperf3-docker
   sleep 1
done

