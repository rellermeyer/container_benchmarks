#!/bin/bash

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

#Set up a fresh ubuntu KVM guest
. ../../base/kvm/start_new.sh

OLD_DIR=$(pwd)
YCSB_FOLDER=../../base/YCSB/YCSB/
MEMCACHED_HOME="/home/ubuntu/memcached/"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir $MEMCACHED_HOME"
scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:$MEMCACHED_HOME/install_KVM_side.sh

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "cd  $MEMCACHED_HOME && sudo chmod +x install_KVM_side.sh && $MEMCACHED_HOME/install_KVM_side.sh"

mkdir -p ../../results/memcached
cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR > $OLD_DIR/../../results/memcached/kvm-$WORKLOAD-$i 2>&1
done
