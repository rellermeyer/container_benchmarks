#!/bin/bash
FIRECRACKER_VERSION=0.21.1
KERNEL_NAME=vmlinux.bin
ROOTFS_NAME=rootfs.ext4
ROOTFS_BACKUP_NAME=rootfs.back.ext4
ROOTFS_SIZE=30G

HOST_NET_IFACE="eno1"
IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

function send-to-fc {
    screen -S firecracker-session -p 0 -X stuff "$1"
    screen -S firecracker-session -p 0 -X stuff "^M"
    sleep 1
} 

echo "Starting automated firecracker setup"
echo "This will remove the existing rootfs $ROOTFS_NAME if it exists."
echo "This will shutdown existing firecracker instance in screen"
echo "Need sudo for setting up tap device on host"
sudo echo ""
sleep 5

set -x 

../clean_instances.sh


echo "Downloading firecracker v$FIRECRACKER_VERSION"
wget -c https://github.com/firecracker-microvm/firecracker/releases/download/v$FIRECRACKER_VERSION/firecracker-v$FIRECRACKER_VERSION-x86_64 -O firecracker
chmod +x firecracker

wget -c https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin -O $KERNEL_NAME

#Delete the potentially used image, and copy the backup one to use as new image. 
#If backup doesn't exist, download it.
if ! [ -f "$ROOTFS_BACKUP_NAME" ]; then
    wget -c https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4 -O $ROOTFS_BACKUP_NAME
fi
rm -rf $ROOTFS_NAME
cp $ROOTFS_BACKUP_NAME $ROOTFS_NAME

echo "Enlarging rootfs to $ROOTFS_SIZE"
e2fsck -f $ROOTFS_NAME && resize2fs $ROOTFS_NAME $ROOTFS_SIZE

echo "Setting up networking on host"
sudo ip link del tap0
sudo iptables -F
sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.16.0.10/24 dev tap0
sudo ip link set tap0 up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o $HOST_NET_IFACE -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o $HOST_NET_IFACE -j ACCEPT

echo "Starting firecracker"
sudo rm -f /tmp/firecracker2.socket
screen -S firecracker-session -d -m ./firecracker --api-sock /tmp/firecracker2.socket --config-file vm-config.json
echo "Firecracker starting up"
sleep 10
echo "Setting up networking"
screen -S firecracker-session -p 0 -X stuff "root^M"; sleep 3;
screen -S firecracker-session -p 0 -X stuff "root^M"; sleep 3;
send-to-fc "ip addr add $IP_ADDR/24 dev eth0"
send-to-fc "ip link set eth0 up"
send-to-fc "ip route add default via 172.16.0.10 dev eth0"
send-to-fc "echo 'nameserver 8.8.8.8' | tee /etc/resolv.conf"

echo "Setting up ssh"
send-to-fc "apk add openssh git bash" && sleep 10
send-to-fc "echo 'ssh-rsa <pubkey>' | tee -a /authorized_keys"
send-to-fc "echo 'PermitRootLogin yes' | tee -a /etc/ssh/sshd_config"
send-to-fc "sed -i '/AuthorizedKeysFile/c\AuthorizedKeysFile /authorized_keys' /etc/ssh/sshd_config" && sleep 3
send-to-fc "/usr/sbin/sshd"

echo "If everything went well, you can attach using screen -r or ssh:"
echo "ssh $SSH_OPTIONS root@$IP_ADDR"