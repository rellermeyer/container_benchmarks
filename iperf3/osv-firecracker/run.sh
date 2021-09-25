#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"
IP_ADDR="172.16.0.2" #harcoded by OSv firecracker

. ../../base/osv/setup.sh

cd $OSV_DIR

./scripts/build image=iperf3
sudo ./scripts/firecracker.py -m $OSV_MEM -c $OSV_CPUS -n -e "/tools/iperf3 -s" &

sleep 5;

cd $OLD_DIR

. ../bench_base.sh
bench_iperf $IP_ADDR "osvfc"
