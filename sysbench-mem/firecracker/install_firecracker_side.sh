#!/bin/bash
apk add make autoconf automake git libtool gcc musl-dev
git clone https://github.com/akopytov/sysbench.git
cd sysbench && ./autogen.sh && ./configure --without-mysql && make && make install 
mv /usr/local/bin/sysbench /sysbench

