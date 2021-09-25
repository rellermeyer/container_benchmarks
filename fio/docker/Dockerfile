FROM ubuntu:18.04

RUN apt-get update
RUN apt install -y git make gcc zlib1g-dev libaio1 libaio-dev fio
COPY test.fio /
RUN printf "\n \t Ready to run fio. Make sure to mount a volume and adjust the filename in test.fio to point to that volume!\n"
ENTRYPOINT fio /test.fio; fio /test.fio; fio /test.fio
    
