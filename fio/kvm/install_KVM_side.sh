#!/bin/bash

FIO_HOME="/home/ubuntu/fio"

sudo apt-get update && sudo apt-get install -y git make gcc zlib1g-dev libaio1 libaio-dev \
    && cd $FIO_HOME \
    && git clone git://git.kernel.dk/fio.git \
    && cd fio && ./configure && make && sudo make install 

fio /home/ubuntu/fio/test.fio --warnings-fatal > /home/ubuntu/result



