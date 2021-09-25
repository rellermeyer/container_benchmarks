#!/bin/bash

# NOTE: mysql its data_dir is at /var/lib/mysql
# you can mount a volume there and also pick a storage driver to use. 
# ## ORIGINAL TABLECOUNT=3, MAXTIME=60 (in comparison paper), TABLESIZE=1000000
# ## ~48 GB = 20 tables * 10 000 000 rows -> ~240 bytes per row


docker stop sysbench-docker
docker build -t sysbench-docker .
../../base/clean_instances.sh

. ../bench_base.sh

#runsc and kata-runtime fail with 
# FATAL: unable to connect to MySQL server on host '127.0.0.1', port 3307, aborting...
# FATAL: error 2013: Lost connection to MySQL server at 'reading initial communication packet', system error: 0
mkdir -p ../../results/mysql

for RUNTIME in kata-runtime; do  #runc runsc

    docker volume rm mysql-volume
    docker volume create mysql-volume

    docker run -d \
        --runtime=$RUNTIME --memory=32768M --cpus=16 \
        --name sysbench-docker -p3306:3306 -e RUNTIME=$RUNTIME\
        --mount type=volume,src=mysql-volume,dst=/var/lib/mysql \
        sysbench-docker 

    sleep 5;
    IP_ADDR=$(docker inspect sysbench-docker | jq -r '.[].NetworkSettings.Networks[].IPAddress')

    bench_mysql $IP_ADDR sysbench ubuntu root4me2 3306 $(echo $RUNTIME)

    docker stop sysbench-docker
    sleep 5
    docker rm sysbench-docker
done

