#!/bin/bash

apk add make git gcc musl-dev
git clone https://github.com/esnet/iperf.git
cd iperf && ./configure && make && make install

LOCAL_IP=$(ifconfig | grep inet\ addr | cut -d ":" -f2 | cut -d " " -f 1)

echo "Starting iperf3 now on: $LOCAL_IP"
iperf3 -s -D &