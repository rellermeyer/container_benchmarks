#!/bin/bash
../../base/clean_instances.sh

docker build -t sysbench-ram-scone .
mkdir -p ../../results/sysbenchmem
docker run -it --memory=32768M --cpus=16 --name sysbench-ram-scone sysbench-ram-scone > ../../results/sysbenchmem/scone

docker stop sysbench-ram-scone
docker rm sysbench-ram-scone