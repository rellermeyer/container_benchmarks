#!/bin/bash

if ! [ -x "$(command -v gcc)" ]; then
  echo 'Error: gcc is not installed.' >&2
  exit 1
fi

mkdir -p ../../results/STREAM/
gcc stream.c -DSTREAM_ARRAY_SIZE=100000000 -O2 -o stream_c.exe
for i in {1..10}; do ./stream_c.exe >> ../../results/STREAM/native; done 

