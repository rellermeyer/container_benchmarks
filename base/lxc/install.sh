#!/bin/bash

SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

if ! [ -x "$(command -v lxd)" ]; then
    echo "Error: lxd is not installed." >&2
    echo "This will also destroy your default zpool"
    sleep 3
    sudo snap remove lxd
    sudo apt-get install zfsutils-linux 
    sudo zpool destroy default
    sudo snap install lxd
    cat preseed.yaml | sudo lxd init --preseed
fi


../../base/clean_instances.sh

if [ "$(sudo lxc info ubuntu | grep plain-ubuntu | wc -l)" -ne "1" ]; then
    echo "No plain-ubuntu snapshots found. Building it now."
    sudo lxc launch ubuntu:18.04 ubuntu && sleep 3
    sudo lxc exec ubuntu -- /bin/bash -c "systemctl disable --now apt-daily{,-upgrade}.{timer,service}"
    sudo lxc exec ubuntu -- /bin/bash -c "echo 'ssh-rsa <pubkey>' | sudo tee -a /authorized_keys"
    sudo lxc exec ubuntu -- /bin/bash -c  "echo 'PermitRootLogin yes' | tee -a /etc/ssh/sshd_config"
    sudo lxc exec ubuntu -- /bin/bash -c "sed -i '/AuthorizedKeysFile/c\AuthorizedKeysFile /authorized_keys' /etc/ssh/sshd_config" && sleep 3
    sudo lxc exec ubuntu -- /bin/bash -c  "systemctl restart sshd" 
    sudo lxc exec ubuntu -- /bin/bash -c  "sudo apt-get update && sudo apt-get install -y git make gcc" 
    sudo lxc stop ubuntu
    sudo lxc snapshot ubuntu plain-ubuntu
fi

sudo lxc restore ubuntu plain-ubuntu; sleep 1
sudo lxc config set ubuntu limits.cpu 16
sudo lxc config set ubuntu limits.memory 32048MB
sudo lxc start ubuntu; sleep 1
sudo lxc restart ubuntu 

sleep 5

IP_ADDR=$(sudo lxc list --format json | jq -r '.[0] | .state.network.eth0.addresses | first | .address')

printf "\n Setup is done; should be able to connect like: "
printf "\n ssh $SSH_OPTIONS root@$IP_ADDR"