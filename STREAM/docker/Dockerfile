FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install make gcc

COPY Makefile .
COPY stream.c .

RUN make stream_c.exe
ENTRYPOINT bash -c "for i in {1..10}; do /stream_c.exe >> /result; done"
#still have to optimize compilation and threading, 
#something like this stream.c -o stream.100M

