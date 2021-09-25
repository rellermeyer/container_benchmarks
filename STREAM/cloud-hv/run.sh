#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

mkdir -p ../../results/STREAM/

scp $SSH_OPTIONS install_cloudhv_side.sh root@$IP_ADDR:/install_cloudhv_side.sh
scp $SSH_OPTIONS stream.c root@$IP_ADDR:/stream.c
scp $SSH_OPTIONS Makefile root@$IP_ADDR:/Makefile

ssh $SSH_OPTIONS root@$IP_ADDR "/install_cloudhv_side.sh"
scp $SSH_OPTIONS root@$IP_ADDR:/result ../../results/STREAM/cloudhv