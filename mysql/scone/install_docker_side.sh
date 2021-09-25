#!/bin/bash
/usr/local/mysql/bin/mysqld -u root &
sleep 10
/usr/local/mysql/bin/mysql < /user_install.sql

TABLE_SIZE=100000

sleep 5
set -x 

sysbench oltp_read_write --tables=3 --table_size=$TABLE_SIZE --mysql-host=localhost --mysql-db=sysbench --db-driver=mysql --mysql-port=3306 --mysql-user=ubuntu --mysql-password=root4me2 prepare

runId=1
while [ $runId -le 5 ]
do  
    numThreads=10
    while [ $numThreads -le 100 ]
    do
        sysbench oltp_read_write --tables=3 --table_size=$TABLE_SIZE --threads=$numThreads --mysql-host=localhost --mysql-db=sysbench --db-driver=mysql --mysql-port=3306 --mysql-user=ubuntu --mysql-password=root4me2 run > /results/scone-$runId-$numThreads
        sleep 3
        numThreads=$(($numThreads + 10))
    done 
    runId=$(($runId + 1))
done

sysbench oltp_read_write --tables=3 --mysql-db=sysbench --mysql-host=localhost --db-driver=mysql --mysql-port=3306 --mysql-user=ubuntu --mysql-password=root4me2 cleanup &> /dev/null