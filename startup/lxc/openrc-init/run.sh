#!/bin/bash
sudo lxc stop alpine-boot
sudo lxc delete alpine-boot

sudo lxc init images:alpine/3.12 alpine-boot
sudo lxc start alpine-boot; sleep 1
sudo lxc file push printmsg alpine-boot/etc/init.d/printmsg
sudo lxc exec alpine-boot -- /bin/sh -c "chmod +x /etc/init.d/printmsg"
sudo lxc exec alpine-boot -- /bin/sh -c "rc-update add printmsg"
sudo lxc exec alpine-boot -- /bin/sh -c "rc-update del networking default"
sudo lxc exec alpine-boot -- /bin/sh -c "rc-update del crond default"

sudo lxc stop alpine-boot
sleep 1

for i in {1..200}; do
    echo "Starting lxc-$i"
    START_TIME=$(date +%s%N)
    output=$(sudo lxc start alpine-boot --console 2> tmp 1>&2) &
    while true; do 
        if grep -Fq "bbbooted" tmp
        then
            END_TIME=$(date +%s%N)
            DIFF_MS=$((($END_TIME-$START_TIME)/1000000))
            echo "$DIFF_MS" >> result
            rm tmp
            break
        fi
    done

    sudo lxc stop alpine-boot
    sleep 1
done

sudo lxc stop alpine-boot
sudo lxc delete alpine-boot

