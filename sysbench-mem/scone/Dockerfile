FROM sconecuratedimages/crosscompilers

RUN apk add make autoconf automake git libtool bash
RUN git clone https://github.com/akopytov/sysbench.git
RUN cd sysbench && ./autogen.sh && ./configure --without-mysql && make && make install 

COPY benchmark.sh /benchmark.sh

ENTRYPOINT bash /benchmark.sh