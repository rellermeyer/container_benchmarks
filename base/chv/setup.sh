#!/bin/bash
set -x
CPUS=16
MEM="32768M"

HOST_NET_IFACE=eno1
IP_ADDR="172.16.0.31"

SSH_OPTIONS="-i ../id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"


function send-to-chv {
    screen -S chv-session -p 0 -X stuff "$1"
    screen -S chv-session -p 0 -X stuff "^M"
    sleep 1
} 

../clean_instances.sh

if ! [ -f "./cloud-hypervisor" ]; then
    echo "Cloud-hypervisor binary not found, building it now"
    make
fi

sudo ip link del tap0
sudo iptables -F
sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.16.0.10/24 dev tap0
sudo ip link set tap0 up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o $HOST_NET_IFACE -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o $HOST_NET_IFACE -j ACCEPT

rm -rf $ROOT_IMG
cp $ROOT_BACKUP_IMG $ROOT_IMG

screen -S chv-session -d -m ./cloud-hypervisor --kernel ./hypervisor-fw \
    --disk path=$ROOT_IMG \
    --cpus boot=$CPUS \
    --memory size=$MEM \
    --net "tap=tap0,mac=AA:AB:00:00:00:01,mask=255.255.255.0"

sleep 30

screen -S chv-session -p 0 -X stuff "root^M"; sleep 2;
screen -S chv-session -p 0 -X stuff "root4me2^M"; sleep 2;
screen -S chv-session -p 0 -X stuff "root4me2^M"; sleep 2;

# send-to-chv "sudo swupd autoupdate --disable" #disable automatic updates because it locks swupd
send-to-chv "ip addr add $IP_ADDR/24 dev ens3"
send-to-chv "ip link set ens3 up"
send-to-chv "ip route add default via 172.16.0.10 dev ens3"
send-to-chv "echo 'ssh-rsa <pubkey>' | tee -a /authorized_keys"
send-to-chv "echo 'PermitRootLogin yes' | tee -a /etc/ssh/sshd_config"
send-to-chv "echo 'AuthorizedKeysFile /authorized_keys' | tee -a /etc/ssh/sshd_config" && sleep 3

echo "ssh $SSH_OPTIONS root@$IP_ADDR"