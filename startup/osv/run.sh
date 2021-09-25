#!/bin/bash
OLD_DIR=$(pwd)
OSV_DIR="../../base/osv/osv"
FIRECRACKER="../../base/firecracker/firecracker"

ITER=300

# . ../../base/osv/setup.sh
cd $OSV_DIR

OSV_MEM=256M
OSV_CPUS=1

./scripts/build fs=rofs image=native-example
sleep 1
cd $OLD_DIR

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit
fi


mkdir -p results

function measure-endtoend {
    for i in $(seq $ITER); do
        echo "Starting $1-$i"
        us_start=$(($(date +%s%N)))
        $2 &> /dev/null
        us_end=$(($(date +%s%N)))
        us_time=$(expr $us_end - $us_start)
        echo $(expr $us_time / 1000000) >> $OLD_DIR/results/$1
        sleep 1
    done
    echo "Done $1"
    sleep 1
}

function measure-grep {
    for i in $(seq $ITER); do
        echo "Starting $1-$i"
        us_start=$(($(date +%s%N)))
        $2 2> $OLD_DIR/tmp 1>&2 
        while true; do 
        if grep -Fq "Cmdline:" $OLD_DIR/tmp; then
            us_end=$(($(date +%s%N)))
            us_time=$(expr $us_end - $us_start)
            echo $(expr $us_time / 1000000) >> $OLD_DIR/results/$1
            rm $OLD_DIR/tmp
            sleep 1
            break
        fi
        done
    done
    echo "Done $1"
    sleep 1
}


measure-endtoend result-qemu "qemu-system-x86_64 -m 256M -smp 1 -vnc :1 -device virtio-blk-pci,id=blk0,drive=hd0,scsi=off,bootindex=0 -drive file=/path/to/usr.img,if=none,id=hd0,cache=none,aio=native -netdev user,id=un0,net=192.168.122.0/24,host=192.168.122.1 -device virtio-net-pci,netdev=un0 -device virtio-rng-pci -enable-kvm -cpu host,+x2apic -chardev stdio,mux=on,id=stdio,signal=off -mon chardev=stdio,mode=readline -device isa-serial,chardev=stdio"
measure-endtoend result-fc "$FIRECRACKER --no-api --config-file osv-fc.json"
measure-endtoend result-uvm "qemu-system-x86_64 -m 256M -smp 1 --nographic -kernel /path/to/kernel.elf -append --nopci -append --console=serial -M microvm,x-option-roms=off,pit=off,pic=off,rtc=off -nodefaults -no-user-config -no-reboot -global virtio-mmio.force-legacy=off -device virtio-blk-device,id=blk0,drive=hd0,scsi=off -drive file=/path/to/usr.img,if=none,id=hd0,cache=none,aio=native -netdev user,id=un0,net=192.168.122.0/24,host=192.168.122.1 -device virtio-net-device,netdev=un0 -enable-kvm -cpu host,+x2apic -serial stdio"

measure-grep result-qemu-grep "qemu-system-x86_64 -m 256M -smp 1 -vnc :1 -device virtio-blk-pci,id=blk0,drive=hd0,scsi=off,bootindex=0 -drive file=/path/to/usr.img,if=none,id=hd0,cache=none,aio=native -netdev user,id=un0,net=192.168.122.0/24,host=192.168.122.1 -device virtio-net-pci,netdev=un0 -device virtio-rng-pci -enable-kvm -cpu host,+x2apic -chardev stdio,mux=on,id=stdio,signal=off -mon chardev=stdio,mode=readline -device isa-serial,chardev=stdio"
measure-grep result-fc-grep "$FIRECRACKER --no-api --config-file osv-fc.json"
measure-grep result-uvm-grep "qemu-system-x86_64 -m 256M -smp 1 --nographic -kernel /path/to/kernel.elf -append --nopci -append --console=serial -M microvm,x-option-roms=off,pit=off,pic=off,rtc=off -nodefaults -no-user-config -no-reboot -global virtio-mmio.force-legacy=off -device virtio-blk-device,id=blk0,drive=hd0,scsi=off -drive file=/path/to/usr.img,if=none,id=hd0,cache=none,aio=native -netdev user,id=un0,net=192.168.122.0/24,host=192.168.122.1 -device virtio-net-device,netdev=un0 -enable-kvm -cpu host,+x2apic -serial stdio"
