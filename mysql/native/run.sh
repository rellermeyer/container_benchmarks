#!/bin/bash

. ../bench_base.sh
# bench_mysql(ip address, db, username, password, port, platform name)
bench_mysql $IP_ADDR "sysbench" ubuntu root4me2 3306 native