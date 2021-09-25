#!/bin/bash
OLD_DIR=$(pwd)
YCSB_FOLDER=../../base/YCSB/YCSB/
IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/memcached

scp $SSH_OPTIONS install_firecracker_side.sh root@$IP_ADDR:/install_firecracker_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "/install_firecracker_side.sh"

mkdir -p results
cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR > $OLD_DIR/../../results/memcached/firecracker-$WORKLOAD-$i 2>&1
done