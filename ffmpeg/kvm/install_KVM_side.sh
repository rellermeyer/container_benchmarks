#!/bin/bash

FFMPEG_HOME="/home/ubuntu/ffmpeg"

mkdir -p $IPERF_HOME \
&& cd $IPERF_HOME 

wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz
tar -xvf ffmpeg-4.2.1-amd64-static.tar.xz 
cd ffmpeg-4.2.1-amd64-static

for RUN in $(seq 5); do
        us_start=$(($(date +%s%N)))
        ./ffmpeg -i /home/ubuntu/base-video.mp4 -c:v hevc -threads 16 out$RUN.HEVC.mp4
        us_end=$(($(date +%s%N)))
        us_time=$(expr $us_end - $us_start)
        echo $(expr $us_time / 1000000) >> $FFMPEG_HOME/result
done