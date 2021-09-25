#!/bin/bash
IP_ADDR="172.16.0.31"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"
MYSQL_USER_INSTALL_PATH="../../base/user_install.sql"
MYSQL_CNF_PATH="../../base/my.cnf"
TABLE_SIZE=10000

OLD_DIR=$(pwd)
cd ../../base/chv/ && ./setup.sh
cd $OLD_DIR

scp $SSH_OPTIONS install_cloudhv_side.sh root@$IP_ADDR:/install_cloudhv_side.sh
scp $SSH_OPTIONS $MYSQL_CNF_PATH root@$IP_ADDR:/etc/my.cnf
scp $SSH_OPTIONS $MYSQL_USER_INSTALL_PATH root@$IP_ADDR:/user_install.sql

ssh $SSH_OPTIONS root@$IP_ADDR "/install_cloudhv_side.sh"

. ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
bench_mysql $IP_ADDR sysbench ubuntu root4me2 3306 cloudhv