#!/bin/bash

IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR

scp $SSH_OPTIONS install_firecracker_side.sh root@$IP_ADDR:/install_firecracker_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "/install_firecracker_side.sh" &

sleep 30

. ../bench_base.sh
bench_netperf 15 $IP_ADDR firecracker