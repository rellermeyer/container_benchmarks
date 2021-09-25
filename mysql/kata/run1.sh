#!/bin/bash
printf "Stopping any running sysbench containers... \n"
docker stop -t 30 sysbench1
printf "Removing any sysbench containers... \n"
docker rm sysbench1
printf "Running sysbench container and attaching to logs \n"
docker run -d --runtime=kata-runtime --name sysbench1 sysbench /home/ubuntu/mysql/run_mysql_experiment.sh
