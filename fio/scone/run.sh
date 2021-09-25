#!/bin/bash
docker stop fio-scone && docker rm fio-scone
docker build -t fio-scone .
../../base/clean_instances.sh

mkdir -p ../../results/fio/

for RUN in $(seq 3); do
    docker volume rm fio-volume
    docker volume create fio-volume
    echo 3 | sudo tee /proc/sys/vm/drop_caches

    docker run -it --name fio-scone --memory=32768M --cpus=16 --mount type=volume,src=fio-volume,dst=/fio-volume fio-scone

    docker cp fio-scone:/result ./result
    cat ./result > ../../results/fio/scone-$RUN
    rm ./result
    
    docker stop fio-scone && docker rm fio-scone
done