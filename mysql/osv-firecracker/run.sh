#!/bin/bash

OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cp ../../base/my.cnf $OSV_DIR/apps/mysql/install/etc/my.cnf

cd $OSV_DIR \
    && ./scripts/build -j4 fs_size_mb=20000 image=mysql \
    && sudo scripts/firecracker.py -m$OSV_MEM -c $OSV_CPUS -n &

cd $OLD_DIR
sleep 10

IP_ADDR="172.16.0.2"
. ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
bench_mysql $IP_ADDR "test" admin osv 3306 osvfc
