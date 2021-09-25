#!/bin/bash

OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cp ../../base/my.cnf $OSV_DIR/apps/mysql/my.cnf

cd $OSV_DIR \
    && ./scripts/build -j4 fs_size_mb=30000 image=mysql \
    && sudo scripts/run.py -D -m$OSV_MEM -c $OSV_CPUS -nv

cd $OLD_DIR
sleep 10

IP_ADDR=$(virsh net-dhcp-leases default | grep osv | cut -d' ' -f 16 | cut -d '/' -f 1) 

. ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
bench_mysql $IP_ADDR "test" admin osv 3306 osv
