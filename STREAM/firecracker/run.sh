#!/bin/bash

IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/STREAM/

scp $SSH_OPTIONS install_firecracker_side.sh root@$IP_ADDR:/install_firecracker_side.sh
scp $SSH_OPTIONS stream.c root@$IP_ADDR:/stream.c
ssh $SSH_OPTIONS root@$IP_ADDR "/install_firecracker_side.sh"

mkdir -p $OLD_DIR/results
scp $SSH_OPTIONS root@$IP_ADDR:/result ../../results/STREAM/firecracker
