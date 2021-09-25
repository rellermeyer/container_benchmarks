#!/bin/bash

docker stop fio && docker rm fio
docker build -t fio .

../../base/clean_instances.sh
mkdir -p ../../results/fio/

for RUNTIME in kata-runtime; do  #runc runsc
        sleep 1
	sync
        echo 3 | sudo tee /proc/sys/vm/drop_caches

	echo "-------------------"
	echo "$RUNTIME"
	echo "-------------------"
        docker run --rm --runtime=$RUNTIME -it --memory=32768M --cpus=16 --name fio -v /mnt/nvme/:/mnt/nvme/ fio
	sudo rm -rf /mnt/nvme/testfile-docker
done
