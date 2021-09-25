#!/bin/bash

IPERF_HOME="/home/ubuntu/iperf3"

mkdir -p $IPERF_HOME \
&& cd $IPERF_HOME \
&& wget https://iperf.fr/download/source/iperf-3.1.3-source.tar.gz \
&& tar xz -f iperf-3.1.3-source.tar.gz \
&& sudo apt-get install -y lib32z1 \
&& cd iperf-3.1.3 \
&& ./configure && make && sudo make install \
&& sudo ldconfig \
&& printf "Starting iperf3 server on port 5201: iperf3 -s" \
&& iperf3 -s -D