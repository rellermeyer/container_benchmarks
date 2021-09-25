#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

ssh $SSH_OPTIONS root@$IP_ADDR "iperf3 -s -D &" &

. ../bench_base.sh
bench_iperf $IP_ADDR "cloudhv"


