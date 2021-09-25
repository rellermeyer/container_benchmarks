#!/bin/bash

docker stop netperf 
docker stop netperfscone
../../base/clean_instances.sh

docker build -t netperf .

for RUNTIME in runc runsc kata-runtime; do 
        docker run --runtime=$RUNTIME -dt --memory=32768M --cpus=16 --rm --name netperf -p 12865:12865 netperf 

        sleep 5

        IP_ADDR=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' netperf)
        
        . ../bench_base.sh
        bench_netperf 15 $IP_ADDR $(echo $RUNTIME)
        sleep 1

        docker stop netperf
        sleep 5
done


