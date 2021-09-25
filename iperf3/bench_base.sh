#!/bin/bash

function bench_iperf {
    echo "host $1"
    echo "filename $2"
    mkdir -p ../../results/iperf3

    sleep 4

    for i in {1..5}; do
    iperf3 -c $1 -t 15 > ../../results/iperf3/$2-$i
    done
}





