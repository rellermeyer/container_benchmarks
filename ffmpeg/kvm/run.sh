#!/bin/bash
#Set up a fresh ubuntu KVM guest
mkdir -p ../../results/ffmpeg
. ../../base/kvm/start_new.sh

FFMPEG_HOME="/home/ubuntu/ffmpeg"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir -p $FFMPEG_HOME"
scp $SSH_OPTIONS ../../base/base-video.mp4 ubuntu@$IP_ADDR:/home/ubuntu/base-video.mp4
scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:$FFMPEG_HOME/install_KVM_side.sh
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "$FFMPEG_HOME/install_KVM_side.sh"


scp $SSH_OPTIONS ubuntu@$IP_ADDR:$FFMPEG_HOME/result ../../results/ffmpeg/kvm
