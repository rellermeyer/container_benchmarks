#!/bin/bash

echo "Attempting to kill any running instances of any platform..."
sudo killall cloud-hypervisor
sudo killall qemu-system-x86_64
sudo killall firecracker; sudo rm -f /tmp/firecracker.socket
screen -wipe

if ! [ -z $(docker ps -aq) ]; then
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
fi

if [ "$(virsh list | grep ubuntu18 | wc -l)" -eq "1" ]
then
    virsh shutdown ubuntu18
    cat /dev/null | sudo tee /var/lib/libvirt/dnsmasq/virbr0.status
fi

sudo lxc stop ubuntu --force #if not forced, it simply hangs 1/10 times
sleep 1

for APP in e2fsck resize2fs screen ssh
do
    if ! [ -x "$(command -v $APP)" ]; then
    echo "Error: $APP is not installed." >&2
    exit 1
    fi
done

#flush writes