#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"
YCSB_FOLDER=../../base/YCSB/YCSB/

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/memcached/

THREADS=16
MEMCACHED_MEM=20000

ssh $SSH_OPTIONS root@$IP_ADDR "sudo swupd bundle-add memcached"
ssh $SSH_OPTIONS root@$IP_ADDR "memcached -u root -t $THREADS -m$MEMCACHED_MEM -d" 

cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR > $OLD_DIR/../../results/memcached/cloudhv-$WORKLOAD-$i 2>&1
done