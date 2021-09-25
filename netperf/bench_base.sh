#!/bin/bash

# $1: length to run for (s)
# $2: ip address
# $3: filename
function bench_netperf {
sleep 3
sudo service netperf stop
mkdir -p ../../results/netperf

runId=1
while [ $runId -le 5 ]; do  
        netperf -l $1 -t TCP_RR -p 12865 -H $2 -- -r 100,200 -o P50_LATENCY,P90_LATENCY,P99_LATENCY,STDDEV_LATENCY >> ../../results/netperf/$3
        netperf -l $1 -t UDP_RR -p 12865 -H $2 -- -r 100,200 -o P50_LATENCY,P90_LATENCY,P99_LATENCY,STDDEV_LATENCY >> ../../results/netperf/$3
        runId=$(($runId + 1))
done
}