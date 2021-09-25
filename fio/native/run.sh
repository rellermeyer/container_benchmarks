#!/bin/bash

if ! [ -x "$(command -v fio)" ]; then
  echo 'Error: fio is not installed.' >&2
  exit 1
fi

mkdir -p ../../results/fio/

for RUN in 2 3; do
  echo 3 | sudo tee /proc/sys/vm/drop_caches
  systemd-run --scope -p MemoryLimit=2048M fio ./test.fio --warnings-fatal > ../../results/fio/native-$RUN
done