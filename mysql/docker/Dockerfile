FROM ubuntu:18.04

ADD mysql-opt.cnf /etc/my.cnf
ADD user_install.sql /user_install.sql

RUN mkdir -p /results
RUN apt-get update --fix-missing && apt-get -y install mysql-server libmysqlclient20 libmysqlclient-dev sysbench

ADD install_docker_side.sh /install.sh

ENTRYPOINT /install.sh
