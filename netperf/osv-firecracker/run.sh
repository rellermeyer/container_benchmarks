#!/bin/bash

OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cd $OSV_DIR \
    && ./scripts/build image=netperf \
    && sudo scripts/firecracker.py -m$OSV_MEM -c $OSV_CPUS -n &

cd $OLD_DIR

sleep 10

IP_ADDR="172.16.0.2" #harcoded by OSv firecracker

. ../bench_base.sh
bench_netperf 15 $IP_ADDR osvfc
