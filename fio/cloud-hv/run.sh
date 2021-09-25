#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
mkdir -p ../../results/fio

for RUN in $(seq 3); do
    cd ../../base/chv/ && ./setup.sh
    cd $OLD_DIR

    echo 3 | sudo tee /proc/sys/vm/drop_caches

    scp $SSH_OPTIONS test.fio root@$IP_ADDR:/test.fio
    ssh $SSH_OPTIONS root@$IP_ADDR "sudo swupd bundle-add fio"
    ssh $SSH_OPTIONS root@$IP_ADDR "fio /test.fio" >> ../../results/fio/cloudhv-$RUN
done