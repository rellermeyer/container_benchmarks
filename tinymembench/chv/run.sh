#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/tinymembench

# scp $SSH_OPTIONS sysbench root@$IP_ADDR:/usr/bin/sysbench
# scp $SSH_OPTIONS ../bench_base.sh root@$IP_ADDR:/benchmark.sh

ssh $SSH_OPTIONS root@$IP_ADDR #"/benchmark.sh" > ../../results/sysbenchmem/cloudhv