#!/bin/bash
printf "Stopping any running sysbench containers... \n"
docker stop -t 30 sysbench1
printf "Removing any sysbench containers... \n"
docker rm sysbench1
printf "Running sysbench container \n"
docker run -it --runtime=runsc --name sysbench1 sysbench /home/ubuntu/mysql/run_mysql_experiment.sh

