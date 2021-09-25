#!/bin/bash

#Set up a fresh ubuntu KVM guest
. ../../base/kvm/start_new.sh

ssh $SSH_OPTIONS ubuntu@$IP_ADDR 