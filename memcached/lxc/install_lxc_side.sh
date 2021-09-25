#!/bin/bash
KVM_CPUS=16
MEMCACHED_MEM=20000

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get -y install make wget gcc libevent-dev 

wget http://www.memcached.org/files/memcached-1.6.6.tar.gz 
tar xz -f memcached-1.6.6.tar.gz 
cd memcached-1.6.6 && ./configure && make && sudo make install
/usr/local/bin/memcached -u root -t $KVM_CPUS -m$MEMCACHED_MEM -d