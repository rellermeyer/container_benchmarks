#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cd $OSV_DIR
./scripts/build image=iperf3
sudo ./scripts/run.py -D -m $OSV_MEM -c $OSV_CPUS -nv -e "/tools/iperf3 -s"

cd $OLD_DIR
sleep 5;
IP_ADDR=$(virsh net-dhcp-leases default | grep osv | cut -d' ' -f 16 | cut -d '/' -f 1)

. ../bench_base.sh
bench_iperf $IP_ADDR "osv"


