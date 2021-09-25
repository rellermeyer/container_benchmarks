FROM ubuntu:18.04

RUN apt update
RUN apt install -y make gcc git
RUN git clone https://github.com/ssvb/tinymembench
RUN cd tinymembench && make

ENTRYPOINT cd tinymembench && for i in $(seq 1); do ./tinymembench; done
