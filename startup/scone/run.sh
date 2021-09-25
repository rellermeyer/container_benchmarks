#!/bin/bash

#It doesn't really make sense to measure the startup time for scone separately I think -- the base image size is different but since no 
#computation is involved we are simply measuring the regular docker startup overhead here.

docker build -t boot-scone .


for i in {1..300}; do
    echo "Starting scone-$i"
    START_TIME=$(date +%s%N)
    docker run -t --rm boot-scone 2> tmp 1>&2 &

    while true; do 
        if grep -Fq "bbbooted" tmp
        then
            END_TIME=$(date +%s%N)
            DIFF_MS=$((($END_TIME-$START_TIME)/1000000))
            echo "$DIFF_MS" >> result
            rm tmp
            break
        fi
    done
done