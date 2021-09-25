#!/bin/bash

SYSBENCH_HOME="/home/ubuntu/sysbench"

sudo apt-get update && sudo apt-get install -y make autoconf automake git libtool gcc pkg-config \
    && cd $SYSBENCH_HOME \
    && git clone https://github.com/akopytov/sysbench.git \
    && cd sysbench && ./autogen.sh && ./configure --without-mysql && make && sudo make install
