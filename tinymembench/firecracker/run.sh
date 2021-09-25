#!/bin/bash
IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/tinymembench
ssh $SSH_OPTIONS root@$IP_ADDR "apk add gcc make git"
ssh $SSH_OPTIONS root@$IP_ADDR "git clone https://github.com/ssvb/tinymembench && cd tinymembench && make"
ssh $SSH_OPTIONS root@$IP_ADDR