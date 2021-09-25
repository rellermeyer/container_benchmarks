#!/bin/bash

. ../../base/lxc/install.sh

NETPERF_HOME="/home/ubuntu/netperf"

ssh $SSH_OPTIONS root@$IP_ADDR "mkdir -p $NETPERF_HOME"
scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:$NETPERF_HOME/install_lxc_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "chmod +x $NETPERF_HOME/install_lxc_side.sh && $NETPERF_HOME/install_lxc_side.sh" &

sleep 90

. ../bench_base.sh
bench_netperf 15 $IP_ADDR lxc