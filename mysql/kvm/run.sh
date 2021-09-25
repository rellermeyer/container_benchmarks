#!/bin/bash
. ../../base/kvm/start_new.sh

MYSQL_CNF_PATH="../../base/my.cnf"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "mkdir /home/ubuntu/mysql/"
scp $SSH_OPTIONS install_KVM_side.sh ubuntu@$IP_ADDR:/home/ubuntu/mysql/install_KVM_side.sh
scp $SSH_OPTIONS $MYSQL_CNF_PATH ubuntu@$IP_ADDR:/home/ubuntu/my.cnf
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "chmod +x /home/ubuntu/mysql/install_KVM_side.sh && /home/ubuntu/mysql/install_KVM_side.sh"

ssh $SSH_OPTIONS ubuntu@$IP_ADDR "sudo mv /home/ubuntu/my.cnf /etc/mysql/my.cnf"
ssh $SSH_OPTIONS ubuntu@$IP_ADDR "sudo systemctl restart mysql"

. ../bench_base.sh
bench_mysql $IP_ADDR sysbench ubuntu root4me2 3306 kvm