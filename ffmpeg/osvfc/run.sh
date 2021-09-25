#!/bin/bash
sudo apt-get install -y yasm libx264-dev libx265-dev
OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"

. ../../base/osv/setup.sh

cd $OSV_DIR
mkdir -p $OLD_DIR/../../results/ffmpeg/


for RUN in $(seq 5); do
    ./scripts/build image=ffmpeg 
    sudo ./scripts/firecracker.py -m $OSV_MEM -c $OSV_CPUS -n -e "/ffmpeg.so -i /base-video.mp4 -c:v hevc -threads 16 out$RUN.HEVC.mp4" | grep encoded | cut -d" " -f5 | cut -d"s" -f1 | awk '{print $1*1000}' >> $OLD_DIR/../../results/ffmpeg/osvfc
done
