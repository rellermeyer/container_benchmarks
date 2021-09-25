#!/bin/bash
set -x 

sudo apt-get update
sudo apt-get -y install mysql-server libmysqlclient20 libtool automake pkg-config libmysqlclient-dev
git clone https://github.com/akopytov/sysbench.git \
    && cd sysbench \
    && ./autogen.sh \
    && ./configure \
    && make -j15 \
    && sudo make install

export SYSBENCH_TABLE_SIZE=1000 
export SYSBENCH_TABLE_COUNT=3 
export SYSBENCH_MAX_TIME=5 #seconds 
export MYSQL_DATABASE=sysbench 
export MYSQL_USER=ubuntu
export MYSQL_PASSWORD=root4me2 

sed -i 's#ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid#ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid --bind-address=0.0.0.0#g' /lib/systemd/system/mysql.service
systemctl daemon-reload
service mysql restart

sudo mysql -u root -password "" < /user_install.sql 

sleep 3
