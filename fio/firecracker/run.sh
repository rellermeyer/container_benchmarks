IP_ADDR="172.16.0.11"
SSH_OPTIONS="-i ../../base/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=60 -o LogLevel=error"

OLD_DIR=$(pwd)
mkdir -p ../../results/fio/

for RUN in $(seq 3); do
    cd ../../base/firecracker/ && ./setup.sh
    cd $OLD_DIR

    echo 3 | sudo tee /proc/sys/vm/drop_caches

    scp $SSH_OPTIONS install_firecracker_side.sh root@$IP_ADDR:/install_firecracker_side.sh
    scp $SSH_OPTIONS test.fio root@$IP_ADDR:/test.fio
    ssh $SSH_OPTIONS root@$IP_ADDR "/install_firecracker_side.sh"

    scp $SSH_OPTIONS root@$IP_ADDR:/result ./result
    cat ./result > ../../results/fio/firecracker-$RUN
    rm ./result
done