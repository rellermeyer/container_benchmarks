#!/bin/bash

NETPERF_HOME="/home/ubuntu/netperf"

sudo apt-get update && sudo apt-get install -y git make gcc autotools-dev automake texinfo \
    && cd $NETPERF_HOME \
    && git clone https://github.com/HewlettPackard/netperf.git \
    && cd netperf && ./autogen.sh && ./configure && make && sudo make install \
    && netserver -D -f -4 -v -p 12865 

