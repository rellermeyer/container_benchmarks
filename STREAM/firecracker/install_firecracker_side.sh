#!/bin/bash
apk add gcc musl-dev
gcc /stream.c -DSTREAM_ARRAY_SIZE=100000000 -O2 -o /stream_c.exe
for i in {1..10}; do /stream_c.exe >> /result; done 