#!/bin/bash

#Set up a fresh ubuntu KVM guest
. ../../base/kvm/start_new.sh

FIO_HOME="/home/ubuntu/fio"
mkdir -p ../../results/fio/

for RUN in $(seq 3); do
    echo 3 | sudo tee /proc/sys/vm/drop_caches

    ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir -p $FIO_HOME"
    scp $SSH_OPTIONS test.fio ubuntu@$IP_ADDR:$FIO_HOME/test.fio
    scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:$FIO_HOME/install_KVM_side.sh
    ssh $SSH_OPTIONS ubuntu@$IP_ADDR "chmod +x $FIO_HOME/install_KVM_side.sh && $FIO_HOME/install_KVM_side.sh"

    scp $SSH_OPTIONS ubuntu@$IP_ADDR:/home/ubuntu/result ./result
    cat ./result > ../../results/fio/kvm-$RUN
    rm ./result
done
