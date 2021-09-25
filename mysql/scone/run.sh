#!/bin/bash
echo "Doesn't work: mysqld crashes"
docker stop mysqlscone
docker rm mysqlscone
../../base/clean_instances.sh

docker build -t mysqlscone .
docker run -it --memory=6096M --cpus=2 --name mysqlscone -p 3311:3306 mysqlscone #probably run detached, untested
# export IP_ADDR=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysqlscone)
docker cp mysqlscone:/results/. ../../results/mysql/
docker stop mysqlscone
# delete it docker rm mysqlscone
# sleep 25;

# . ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
# bench_mysql localhost sysbench ubuntu root4me2 3311 scone