#!/bin/bash
apk add make git automake autoconf gcc musl-dev
git clone https://github.com/HewlettPackard/netperf.git
cd netperf && ./autogen.sh && ./configure && make && make install

/usr/local/bin/netserver -D -f -4 -v -p 12865
