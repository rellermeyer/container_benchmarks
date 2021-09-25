#!/bin/bash

if [ "x$WORKLOAD" == "x" ]; then
    echo "Workload is empty, please set WORKLOAD="
    exit
fi

. ../../base/lxc/install.sh

OLD_DIR=$(pwd)
YCSB_FOLDER=../../base/YCSB/YCSB/
MEMCACHED_HOME="/home/ubuntu/memcached/"

ssh $SSH_OPTIONS root@$IP_ADDR "mkdir $MEMCACHED_HOME"
scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:$MEMCACHED_HOME/install_lxc_side.sh

ssh $SSH_OPTIONS root@$IP_ADDR "cd  $MEMCACHED_HOME && sudo chmod +x install_lxc_side.sh && $MEMCACHED_HOME/install_lxc_side.sh"

mkdir -p ../../results/memcached
cd $YCSB_FOLDER
./bin/ycsb load memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR
for i in {1..3}
do
    ./bin/ycsb run memcached -s -P workloads/$WORKLOAD -p memcached.hosts=$IP_ADDR > $OLD_DIR/../../results/memcached/lxc-$WORKLOAD-$i 2>&1
done
