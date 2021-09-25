#!/bin/bash

if ! [ -x "$(command -v sysbench)" ]; then
  echo 'Error: sysbench is not installed.' >&2
  exit 1
fi

mkdir -p ../../results/fio/
../bench_base.sh > ../../results/sysbenchmem/native

