#!/bin/bash
apk add make wget gcc libevent-dev musl-dev
wget http://www.memcached.org/files/memcached-1.6.6.tar.gz 
tar xz -f memcached-1.6.6.tar.gz 
cd memcached-1.6.6 && ./configure && make && make install

FC_CPUS=16
MEMCACHED_MEM=20000
LOCAL_IP=$(ifconfig | grep inet\ addr | cut -d ":" -f2 | cut -d " " -f 1)

echo "Running memcached with $FC_CPUS CPUs and $MEMCACHED_MEM memory."
echo "You can invoke YCSB tests by running the following in the YCSB folder:"
printf "\t ./bin/ycsb load memcached -s -P workloads/workloada -p memcached.hosts=$LOCAL_IP \n"
printf "\t ./bin/ycsb run memcached -s -P workloads/workloada -p memcached.hosts=$LOCAL_IP \n\n"

/usr/local/bin/memcached -u root -t $FC_CPUS -m$MEMCACHED_MEM -d