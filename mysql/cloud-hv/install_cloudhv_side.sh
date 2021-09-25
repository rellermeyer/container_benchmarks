#!/bin/bash
set -x 
sudo swupd bundle-add make c-basic devpkg-ncurses
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.45.tar.gz
tar zxf mysql-5.6.45.tar.gz
cd mysql-5.6.45 && cmake -DWITH_NUMA=OFF \
    && sed 's/#define HAVE_STACKTRACE 1//g' -i include/my_stacktrace.h \
    && make -j16 \
    && make install 

cd /usr/local/mysql
./scripts/mysql_install_db --force --basedir=./ --ldata=data
./bin/mysqld -u root &
sleep 10
./bin/mysql -u root < /user_install.sql &
