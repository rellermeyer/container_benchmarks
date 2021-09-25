#!/bin/bash

docker stop iperf3-scone
docker build -t iperf3-scone .
../../base/clean_instances.sh

docker run -d --rm --memory=6096M --cpus=2 --name iperf3-scone -p5201:5201 iperf3-scone

sleep 5;

. ../bench_base.sh
bench_iperf localhost "scone"

docker stop iperf3-scone