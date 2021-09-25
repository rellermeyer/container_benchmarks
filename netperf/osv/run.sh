#!/bin/bash

OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cd $OSV_DIR \
    && ./scripts/build image=netperf \
    && sudo scripts/run.py -D -m$OSV_MEM -c $OSV_CPUS -nv

cd $OLD_DIR

sleep 10

IP_ADDR=$(virsh net-dhcp-leases default | grep osv | cut -d' ' -f 16 | cut -d '/' -f 1)

. ../bench_base.sh
bench_netperf 15 $IP_ADDR osv

