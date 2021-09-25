#!/bin/bash

ITER=100

sudo lxc stop alpine-boot
sudo lxc delete alpine-boot

sudo lxc init images:alpine/3.12 alpine-boot
sudo lxc start alpine-boot; sleep 1
sudo lxc exec alpine-boot -- /bin/sh -c "rm /sbin/init"
sudo lxc file push init alpine-boot/sbin/init
sudo lxc stop alpine-boot; sleep 1

for i in $(seq $ITER); do
    echo  "Starting lxc-$i"
    us_start=$(($(date +%s%N)))
    sudo lxc start alpine-boot --console
    us_end=$(($(date +%s%N)))
    us_time=$(expr $us_end - $us_start)
    echo $(expr $us_time / 1000000) >> result
    sudo lxc stop alpine-boot
    sleep 4
done

sudo lxc delete alpine-boot
