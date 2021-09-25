sudo apt-get -y install mysql-server libmysqlclient20
mkdir -p /home/ubuntu/mysql && cd /home/ubuntu/mysql && \
 git clone https://github.com/akopytov/sysbench.git && \
cd sysbench && ./autogen.sh && ./configure && make -j15 && sudo make install

export SYSBENCH_TABLE_SIZE=100000 
export SYSBENCH_TABLE_COUNT=3 
export SYSBENCH_MAX_TIME=5 #seconds 
export MYSQL_DATABASE=sysbench 
export MYSQL_USER=ubuntu
export MYSQL_PASSWORD=root4me2 

sudo /etc/init.d/mysql restart

sudo mysql < $MYSQL_SCRIPTS/sql_setup.sql 


echo "Ready to run tests"

