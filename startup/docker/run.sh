#!/bin/bash

# this script only performs the non-OCI version of the benchmark of the containers.

docker build -t boot-docker .
echo ""

mkdir -p results

for RUNTIME in runc runsc kata-runtime; do 
   for i in {1..300}; do
   echo "Starting $RUNTIME-$i"
   START_TIME=$(date +%s%N)
   docker run --runtime=$RUNTIME -t --rm boot-docker 2> tmp 1>&2 &
    
   while true; do 
      if grep -Fq "bbbooted" tmp
      then
         END_TIME=$(date +%s%N)
         DIFF_MS=$((($END_TIME-$START_TIME)/1000000))
         echo "$DIFF_MS" >> results/result-$RUNTIME
         rm tmp
         break
      fi
   done

   sleep 3

   done
done
