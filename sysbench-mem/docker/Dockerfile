FROM ubuntu:18.04

RUN apt update
RUN apt install -y make autoconf automake git libtool gcc pkg-config bash
RUN git clone https://github.com/akopytov/sysbench.git
RUN cd sysbench && ./autogen.sh && ./configure --without-mysql && make && make install

COPY benchmark.sh /benchmark.sh

ENTRYPOINT bash /benchmark.sh 