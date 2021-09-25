#!/bin/bash

for RUN in $(seq 5); do
        us_start=$(($(date +%s%N)))
        /ffmpeg -i /Big_Buck_Bunny_1080_10s_30MB.mp4 -c:v hevc -threads 16 out$RUN.HEVC.mp4
        us_end=$(($(date +%s%N)))
        us_time=$(expr $us_end - $us_start)
        echo $(expr $us_time / 1000000) >> /result
done
