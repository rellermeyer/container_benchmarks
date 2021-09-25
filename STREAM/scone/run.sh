#!/bin/bash
docker stop stream-scone
docker rm stream-scone
set -x 
docker build -t stream-scone .
docker run -it --memory=32768M --cpus=16 --name stream-scone stream-scone
mkdir -p ../../results/STREAM/
docker cp stream-scone:/result ../../results/STREAM/scone

docker stop stream-scone
docker rm stream-scone