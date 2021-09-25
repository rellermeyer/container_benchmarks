FROM sconecuratedimages/crosscompilers

RUN apk add make git automake autoconf
RUN git clone https://github.com/HewlettPackard/netperf.git
RUN cd netperf \
      && ./autogen.sh && ./configure && make && make install

ENTRYPOINT netserver -D -f -4 -v -p 12865

