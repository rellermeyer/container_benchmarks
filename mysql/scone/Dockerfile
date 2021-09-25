FROM sconecuratedimages/crosscompilers

RUN apk add make cmake ncurses-dev bash perl

RUN wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.45.tar.gz
RUN tar zxf mysql-5.6.45.tar.gz
RUN cd mysql-5.6.45 && cmake -DWITH_NUMA=OFF 
RUN cd mysql-5.6.45 && sed 's/#define HAVE_STACKTRACE 1//g' -i include/my_stacktrace.h \
    && make -j4 \
    && make install 

#Change my.cnf to correct innodb_pool_size later
COPY my.cnf /etc/
COPY user_install.sql /
COPY install_docker_side.sh /install.sh

#2 gb
ENV SCONE_HEAP=4000000000
ENV SCONE_STACK=4M
RUN ulimit -s unlimited

WORKDIR /usr/local/mysql/
RUN ./scripts/mysql_install_db --force --basedir=./ --ldata=data

RUN apk add gcc libtool automake make git autoconf mariadb-dev linux-headers musl-dev && \
    git clone https://github.com/akopytov/sysbench && \
    cd sysbench && \ 
    ./autogen.sh && \
    ./configure && \
    make  && \
    make install

# ENTRYPOINT /bin/bash
ENTRYPOINT /install.sh && sleep 10000

# ENTRYPOINT ./bin/mysqld -u root
#sysbench oltp_read_write --tables=2 --table_size=100000 --mysql-host=172.17.0.2 --mysql-db=sysbench --mysql-user=ubuntu --mysql-password=root4me2  --db-driver=mysql --mysql-port=3306 prepare