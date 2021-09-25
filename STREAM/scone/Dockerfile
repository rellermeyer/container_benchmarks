FROM sconecuratedimages/crosscompilers

RUN apk add bash
ENV SCONE_HEAP=20000000000
COPY stream.c .
RUN scone gcc -O2 -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream_c.exe
ENTRYPOINT bash -c "for i in {1..10}; do /stream_c.exe >> /result; done"
