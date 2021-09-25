#!/bin/bash


#flush existing dhcp leases 
#cat /dev/null | sudo tee /var/lib/libvirt/dnsmasq/virbr0.status

guestName="ubuntu18"
MEM=32768
CPUS=16

#Note, following command is dependent on being in the directory that has ks.cfg, otherwise have to pass correct path.
virt-install \
--name $guestName \
--ram $MEM \
--disk path=/home/$USER/$guestName.img,size=30,format=qcow2 \
--vcpus $CPUS \
--virt-type kvm \
--os-type linux \
--os-variant ubuntu18.04 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--noautoconsole \
--location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' \
--initrd-inject=ks.cfg \
--extra-args 'ks=file:/ks.cfg console=ttyS0,115200n8 serial' 

# This waits until installation is done, and then starts the vm
echo "Waiting for virt-install to complete..."
finished="0";
while [ "$finished" = "0" ]; do
    sleep 5;
    if [ `virsh list --all | grep "running" | grep "$guestName" | wc -c` -eq 0 ];
    then
            finished=1;
            echo "Setup finished, starting VM $guestName"
            virsh start $guestName
            sleep 5
    fi
done

IP_ADDR=$(virsh net-dhcp-leases default | tail -n2 | head -n 1 | cut -d' ' -f16| cut -d '/' -f1)
SSH_OPTIONS="-i ../id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60"

 echo "root4me2" > .sshpass
sshpass -f .sshpass ssh $SSH_OPTIONS ubuntu@$IP_ADDR sudo chown -R ubuntu:ubuntu .ssh
rm .sshpass

sleep 1
virsh shutdown $guestName
virsh snapshot-create-as --domain $guestName --name clean_state --description "Snapshot of ubuntu installation right after installing and setting up SSH"
#flush existing dhcp leases 
#cat /dev/null | sudo tee /var/lib/libvirt/dnsmasq/virbr0.status
virsh start $guestName