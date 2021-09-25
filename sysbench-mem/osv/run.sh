#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR=../../base/osv/osv

. ../../base/osv/setup.sh

cd $OSV_DIR
./scripts/manifest_from_host.sh -w sysbench && ./scripts/build app_local_exec_tls_size=320 --append-manifest

mkdir -p $OLD_DIR/../../results/sysbenchmem/

for RUN in $(seq 5); do
    sudo ./scripts/run.py -m$OSV_MEM -c $OSV_CPUS -e "sysbench memory --memory-access-mode=rnd --time=15 run" >> $OLD_DIR/../../results/sysbenchmem/osv
    sleep 3
done