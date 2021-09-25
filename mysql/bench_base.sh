#!/bin/bash

function bench_mysql {
    # $1: ip address
    # $2: db (e.g. sysbench)
    # $3: username
    # $4: password
    # $5: port
    # $6: platform name (e.g. docker)
    TABLE_SIZE=10000000

    sleep 5
    set -x 
    
    mkdir -p ../../results/mysql
    sysbench oltp_read_write --tables=3 --table_size=$TABLE_SIZE --mysql-host=$1 --mysql-db=$2 --db-driver=mysql --mysql-port=$5 --mysql-user=$3 --mysql-password=$4 prepare

    runId=4
    while [ $runId -le 10 ]
    do  
        numThreads=10
        while [ $numThreads -le 160 ]
        do
            sysbench oltp_read_write --tables=3 --table_size=$TABLE_SIZE --time=30 --threads=$numThreads --mysql-host=$1 --mysql-db=$2 --db-driver=mysql --mysql-port=$5 --mysql-user=$3 --mysql-password=$4 run > ../../results/mysql/$6-$runId-$numThreads
            sleep 3
            numThreads=$(($numThreads + 20))
        done 
        runId=$(($runId + 1))
    done

    sysbench oltp_read_write --tables=3 --mysql-db=$2 --mysql-host=$1 --db-driver=mysql --mysql-port=$5 --mysql-user=$3 --mysql-password=$4 cleanup
}
