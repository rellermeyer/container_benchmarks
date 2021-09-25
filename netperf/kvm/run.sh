#!/bin/bash

#Set up a fresh ubuntu KVM guest
. ../../base/kvm/start_new.sh

NETPERF_HOME="/home/ubuntu/netperf"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir -p $NETPERF_HOME"
scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:$NETPERF_HOME/install_KVM_side.sh
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "chmod +x $NETPERF_HOME/install_KVM_side.sh && $NETPERF_HOME/install_KVM_side.sh" &

sleep 120

. ../bench_base.sh
bench_netperf 15 $IP_ADDR kvm