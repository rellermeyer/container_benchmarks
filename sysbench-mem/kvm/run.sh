#!/bin/bash

#Set up a fresh ubuntu KVM guest
. ../../base/kvm/start_new.sh

SYSBENCH_HOME="/home/ubuntu/sysbench"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir -p $SYSBENCH_HOME"
scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:$SYSBENCH_HOME/install_KVM_side.sh
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "chmod +x $SYSBENCH_HOME/install_KVM_side.sh && $SYSBENCH_HOME/install_KVM_side.sh"

mkdir -p ../../results/sysbenchmem
scp $SSH_OPTIONS ../bench_base.sh ubuntu@$IP_ADDR:$SYSBENCH_HOME/benchmark.sh
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "$SYSBENCH_HOME/benchmark.sh" > ../../results/sysbenchmem/kvm