#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

scp $SSH_OPTIONS install_cloudhv_side.sh root@$IP_ADDR:/install_cloudhv_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "/install_cloudhv_side.sh"

. ../bench_base.sh
bench_netperf 30 $IP_ADDR cloudhv