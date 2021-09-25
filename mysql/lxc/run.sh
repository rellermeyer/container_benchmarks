#!/bin/bash

. ../../base/lxc/install.sh

MYSQL_USER_INSTALL_PATH="../../base/user_install.sql"
MYSQL_CNF_PATH="../../base/my.cnf"

scp $SSH_OPTIONS $MYSQL_CNF_PATH root@$IP_ADDR:/etc/my.cnf
scp $SSH_OPTIONS install_lxc_side.sh root@$IP_ADDR:/install_lxc_side.sh
scp $SSH_OPTIONS $MYSQL_USER_INSTALL_PATH root@$IP_ADDR:/user_install.sql
ssh $SSH_OPTIONS root@$IP_ADDR "/install_lxc_side.sh"

mkdir -p ../../results/mysql/
. ../bench_base.sh
bench_mysql $IP_ADDR sysbench ubuntu root4me2 3306 lxc
