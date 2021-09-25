#!/bin/bash

OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"
YCSB_FOLDER="../../base/YCSB/YCSB/"

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

. ../../base/osv/setup.sh

OSV_CPUS=16
cd $OSV_DIR \
    && ./scripts/build image=memcached \
    && sudo scripts/firecracker.py -m $OSV_MEM -c $OSV_CPUS -n -e "memcached -u root -t $OSV_CPUS -m20000" &

sleep 5

cd $OLD_DIR
mkdir -p ../../results/memcached
IP_ADDR="172.16.0.2" #harcoded by OSv firecracker
cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR > $OLD_DIR/../../results/memcached/osvfc-$WORKLOAD-$i 2>&1
done
