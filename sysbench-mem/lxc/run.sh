#!/bin/bash

. ../../base/lxc/install.sh

SYSBENCH_HOME="/home/ubuntu/sysbench"

ssh $SSH_OPTIONS root@$IP_ADDR "mkdir -p $SYSBENCH_HOME"
scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:$SYSBENCH_HOME/install_lxc_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "chmod +x $SYSBENCH_HOME/install_lxc_side.sh && $SYSBENCH_HOME/install_lxc_side.sh"

mkdir -p ../../results/sysbenchmem
scp $SSH_OPTIONS ../bench_base.sh root@$IP_ADDR:/benchmark.sh
ssh $SSH_OPTIONS root@$IP_ADDR "/benchmark.sh" > ../../results/sysbenchmem/lxc