#!/bin/bash

mkdir -p ../../results/ffmpeg
wget -nc https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz && tar -xvf ffmpeg-4.2.1-amd64-static.tar.xz 

cd ffmpeg-4.2.1-amd64-static
rm out*.mp4

for RUN in $(seq 5); do
        us_start=$(($(date +%s%N)))
        taskset -c 0-15 ./ffmpeg -i ../../../base/base-video.mp4 -c:v hevc -threads 16 out$RUN.HEVC.mp4
        us_end=$(($(date +%s%N)))
        us_time=$(expr $us_end - $us_start)
        echo $(expr $us_time / 1000000) >> ../../../results/ffmpeg/native
done

rm -rf ffmpeg-4.2.1*