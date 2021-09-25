#!/bin/bash
OLD_DIR=$(pwd)
YCSB_FOLDER=../../base/YCSB/YCSB/

docker stop memcached-docker
docker build -t memcached-docker .
../../base/clean_instances.sh

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

mkdir -p ../../results/memcached
cd $YCSB_FOLDER

for RUNTIME in runc runsc kata-runtime; do 
    docker run --runtime=$RUNTIME -d --rm --memory=32768M --cpus=16 --name memcached-docker -p 11211:11211 memcached-docker
    
    ./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=127.0.0.1

    for i in {1..3}; do
        ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=127.0.0.1 > $OLD_DIR/../../results/memcached/$RUNTIME-$WORKLOAD-$i 2>&1
    done


    docker stop memcached-docker
    sleep 5
done