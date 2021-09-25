#!/bin/bash
IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR
mkdir -p ../../results/ffmpeg/

scp $SSH_OPTIONS ../../base/base-video.mp4 root@$IP_ADDR:/base-video.mp4
scp $SSH_OPTIONS run_firecracker_side.sh root@$IP_ADDR:/run.sh

ssh $SSH_OPTIONS root@$IP_ADDR "/run.sh" 

scp $SSH_OPTIONS root@$IP_ADDR:/result ../../results/ffmpeg/firecracker