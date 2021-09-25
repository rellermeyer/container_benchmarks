#!/bin/bash
echo "Set up correct recordcount in YCSB repository?"
sleep 3

killall memcached

set -x
for PLATFORM in ./*/; do
    for WORKLOAD in "workloada" "workloadb" "workloadc" "workloadf"; do
        cd $PLATFORM 
        WORKLOAD=$WORKLOAD ./run.sh
        sleep 3
        cd ..
    done
done