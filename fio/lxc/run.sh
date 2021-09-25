#!/bin/bash

FIO_HOME="/home/ubuntu/fio"
mkdir -p ../../results/fio/

set -x 

for RUN in $(seq 3); do
    . ../../base/lxc/install.sh
    echo 3 | sudo tee /proc/sys/vm/drop_caches

    ssh $SSH_OPTIONS root@$IP_ADDR "mkdir -p $FIO_HOME"
    scp $SSH_OPTIONS test.fio root@$IP_ADDR:$FIO_HOME/test.fio
    scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:$FIO_HOME/install_lxc_side.sh
    ssh $SSH_OPTIONS root@$IP_ADDR "chmod +x $FIO_HOME/install_lxc_side.sh && $FIO_HOME/install_lxc_side.sh"
    
    scp $SSH_OPTIONS root@$IP_ADDR:/home/ubuntu/result ./result
    cat ./result > ../../results/fio/lxc-$RUN
    rm ./result
done
