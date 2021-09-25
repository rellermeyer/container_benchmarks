#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

# cp -r ./fio-osv-folder $OSV_DIR/apps/fio \
    cd $OSV_DIR \
    && ./scripts/build image=fio \
    && ./scripts/run.py > output