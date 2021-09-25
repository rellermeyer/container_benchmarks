#!/bin/bash
apk add make git zlib-dev libaio-dev gcc musl-dev linux-headers
git clone git://git.kernel.dk/fio.git
cd fio && ./configure && make && make install

/usr/local/bin/fio /test.fio --warnings-fatal > /result