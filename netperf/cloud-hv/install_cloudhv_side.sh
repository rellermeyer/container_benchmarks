#!/bin/bash
sudo swupd bundle-add git make c-basic texinfo
git clone https://github.com/HewlettPackard/netperf.git
cd netperf && ./autogen.sh && ./configure && make && make install
/usr/local/bin/netserver -f -4 -v -p 12865 &
