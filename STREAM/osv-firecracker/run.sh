#!/bin/bash

OLD_DIR=$(pwd)
OSV_FOLDER=../../base/osv/osv

mkdir -p ../../results/STREAM/

. ../../base/osv/setup.sh

cd $OSV_FOLDER \
    && ./scripts/build image=stream \
    && for i in {1..10}; do sudo ./scripts/firecracker.py -m$OSV_MEM -c $OSV_CPUS >> $OLD_DIR/../../results/STREAM/osv-fc; done

