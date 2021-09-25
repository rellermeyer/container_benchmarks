#!/bin/bash
OLD_DIR=$(pwd)
YCSB_FOLDER="../../base/YCSB/YCSB/"

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

docker stop memcached-scone
docker build -t memcached-scone-heap .
../../base/clean_instances.sh


docker run -d --rm --memory=32768M --cpus=16 --name memcached-scone -p 11211:11211 memcached-scone-heap

mkdir -p ../../results/memcached
cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=127.0.0.1
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=127.0.0.1 > $OLD_DIR/../../results/memcached/scone-$WORKLOAD-$i 2>&1
done

docker stop memcached-scone