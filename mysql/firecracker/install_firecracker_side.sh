#!/bin/bash

apk add make cmake ncurses-dev perl gcc musl-dev g++
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.45.tar.gz
tar zxf mysql-5.6.45.tar.gz
cd mysql-5.6.45 && cmake -DWITH_NUMA=OFF \
    && sed 's/#define HAVE_STACKTRACE 1//g' -i include/my_stacktrace.h \
    && make -j15 \
    && make install 



