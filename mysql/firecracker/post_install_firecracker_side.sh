#!/bin/bash
cd /usr/local/mysql
./scripts/mysql_install_db --force --basedir=./ --ldata=data
./bin/mysqld -u root &
sleep 10
./bin/mysql -u root < /user_install.sql