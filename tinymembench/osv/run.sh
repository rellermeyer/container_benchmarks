#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR=../../base/osv/osv

. ../../base/osv/setup.sh

cd $OSV_DIR
./scripts/manifest_from_host.sh -w tinymembench && ./scripts/build --append-manifest

mkdir -p $OLD_DIR/../../results/tinymembench/

for RUN in $(seq 3); do
    sudo ./scripts/run.py -m$OSV_MEM -c $OSV_CPUS -e "tinymembench"
    sleep 3
done