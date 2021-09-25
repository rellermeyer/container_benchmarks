#!/bin/bash

GUEST_NAME="ubuntu18"

echo "Sudo needed for emptying virtual dhcp leases"
sudo printf ""

../../base/clean_instances.sh

echo "Attempting to shutdown guest $GUEST_NAME"
virsh shutdown $GUEST_NAME
sleep 5
virsh snapshot-revert $GUEST_NAME clean_state
sleep 5

cat /dev/null | sudo tee /var/lib/libvirt/dnsmasq/virbr0.status

virsh start $GUEST_NAME
sleep 15

export IP_ADDR=$(virsh net-dhcp-leases default | tail -n2 | head -n 1 | cut -d' ' -f16| cut -d '/' -f1)

#double since this is executed from the application dirs, have to ../.. back to base folder.
export SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"
