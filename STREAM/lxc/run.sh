#!/bin/bash

. ../../base/lxc/install.sh

STREAM_HOME="/home/ubuntu/STREAM"

mkdir -p ../../results/STREAM/

ssh $SSH_OPTIONS root@$IP_ADDR "mkdir -p $STREAM_HOME"
scp $SSH_OPTIONS Makefile root@$IP_ADDR:$STREAM_HOME/Makefile
scp $SSH_OPTIONS stream.c root@$IP_ADDR:$STREAM_HOME/stream.c

ssh $SSH_OPTIONS root@$IP_ADDR "sudo apt-get update && sudo apt-get install -y make"
ssh $SSH_OPTIONS root@$IP_ADDR "cd $STREAM_HOME && make stream_c.exe"
ssh $SSH_OPTIONS root@$IP_ADDR "for i in {1..10}; do $STREAM_HOME/stream_c.exe >> $STREAM_HOME/result; done"

scp $SSH_OPTIONS root@$IP_ADDR:$STREAM_HOME/result ../../results/STREAM/lxc