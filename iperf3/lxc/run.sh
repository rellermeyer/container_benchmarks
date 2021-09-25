#!/bin/bash

. ../../base/lxc/install.sh

IPERF_HOME="/home/ubuntu/iperf3"

ssh $SSH_OPTIONS root@$IP_ADDR "sudo apt-get update && sudo apt-get install -y git make gcc lib32z1"

ssh $SSH_OPTIONS root@$IP_ADDR "mkdir -p $IPERF_HOME"
scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:$IPERF_HOME/install_lxc_side.sh

ssh $SSH_OPTIONS root@$IP_ADDR "chmod +x $IPERF_HOME/install_lxc_side.sh && $IPERF_HOME/install_lxc_side.sh"

. ../bench_base.sh
bench_iperf $IP_ADDR "lxc"