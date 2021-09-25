FROM sconecuratedimages/crosscompilers

ENV SCONE_HEAP=4147483648
RUN apk add make git
RUN git clone https://github.com/esnet/iperf.git
RUN cd iperf \
    && ./configure && make && make install

ENTRYPOINT iperf3 -s
