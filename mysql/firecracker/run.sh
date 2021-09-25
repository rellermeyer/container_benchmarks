#!/bin/bash

IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"
MYSQL_USER_INSTALL_PATH="../../base/user_install.sql"
MYSQL_CNF_PATH="../../base/my.cnf"

OLD_DIR=$(pwd)
cd ../../base/firecracker/ && ./setup.sh
cd $OLD_DIR

ssh $SSH_OPTIONS root@$IP_ADDR "apk add bash"
scp $SSH_OPTIONS install_firecracker_side.sh root@$IP_ADDR:/install_firecracker_side.sh
ssh $SSH_OPTIONS root@$IP_ADDR "/install_firecracker_side.sh"

scp $SSH_OPTIONS $MYSQL_CNF_PATH root@$IP_ADDR:/etc/my.cnf
scp $SSH_OPTIONS $MYSQL_USER_INSTALL_PATH root@$IP_ADDR:/user_install.sql
scp $SSH_OPTIONS post_install_firecracker_side.sh root@$IP_ADDR:/post_install_firecracker_side.sh

ssh $SSH_OPTIONS root@$IP_ADDR "/post_install_firecracker_side.sh" &

sleep 30

. ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
bench_mysql $IP_ADDR sysbench ubuntu root4me2 3306 firecracker