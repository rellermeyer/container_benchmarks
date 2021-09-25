FROM sconecuratedimages/crosscompilers

RUN apk add make git zlib-dev
RUN git clone git://git.kernel.dk/fio.git
RUN cd fio && ./configure && make
COPY test.fio /

#2 gb
ENV SCONE_HEAP=2147483648


RUN printf "\n \t Ready to run fio. Make sure to mount a volume and adjust the filename in test.fio to point to that volume!\n\n"

ENTRYPOINT /fio/fio /test.fio > /result


    

    