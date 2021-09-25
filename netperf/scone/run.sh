#!/bin/bash

docker stop netperfscone 
docker stop netperf
../../base/clean_instances.sh

docker build -t netperfscone .
docker run -dt --rm --memory=32768M --cpus=16 --name netperfscone -p 12865:12865 netperfscone

sleep 10;

IP_ADDR=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' netperfscone)

. ../bench_base.sh
bench_netperf 30 $IP_ADDR scone



