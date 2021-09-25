#!/bin/bash

. ../../base/lxc/install.sh

scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:/run.sh
scp $SSH_OPTIONS ../../base/base-video.mp4 root@$IP_ADDR:/base-video.mp4
ssh $SSH_OPTIONS root@$IP_ADDR "/run.sh"
scp $SSH_OPTIONS root@$IP_ADDR:/result ../../results/ffmpeg/lxc



