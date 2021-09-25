FROM ubuntu:18.04

RUN apt update
RUN apt install -y git make gcc autotools-dev automake
RUN git clone https://github.com/HewlettPackard/netperf.git
RUN cd netperf && ./autogen.sh && ./configure && make && make install

ENTRYPOINT netserver -D -f -4 -v -p 12865

