#!/bin/bash

echo "Manually create a new profile using"
echo "lxc profile copy default newprofile"
echo "then edit using sudo lxc profile edit newprofile to match config.xml"

for i in {1..5}; do
    sudo lxc stop ubuntu-boot
    sudo lxc delete ubuntu-boot

    sudo lxc init --profile newprofile ubuntu:18.04 ubuntu-boot

    START_TIME=$(date +%s%N)
    output=$(sudo lxc start ubuntu-boot --console 2> tmp 1>&2) &
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

    sudo lxc stop ubuntu-boot
    sudo lxc delete ubuntu-boot

    sleep 3
done 