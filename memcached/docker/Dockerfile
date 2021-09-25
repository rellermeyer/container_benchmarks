FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install make wget gcc libevent-dev 

RUN wget http://www.memcached.org/files/memcached-1.6.6.tar.gz 
RUN tar xz -f memcached-1.6.6.tar.gz 
RUN cd memcached-1.6.6 && ./configure && make && make install

ENTRYPOINT memcached -u root -p 11211 -t 16 -m 20000