#!/bin/bash
/etc/init.d/mysql stop
sed -i 's#su - mysql -s /bin/sh -c "/usr/bin/mysqld_safe > /dev/null 2>\&1 \&"#su - mysql -s /bin/sh -c "/usr/bin/mysqld_safe --bind-address=0.0.0.0 > /dev/null 2>\&1 \&"#g' /etc/init.d/mysql 
/etc/init.d/mysql start
sleep 5
mysql < /user_install.sql

# TABLE_SIZE=100000
sleep 30000