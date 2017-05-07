#!/bin/bash
resource_name=$1
resource_path=$2
mount_point=$3
sudo umount $mount_point
sudo cryptsetup remove $resource_name
loop_device_used=$(losetup -a | grep $(readlink -f ${resource_path}))
if [[ $? -eq 0 ]]; then
    sudo losetup -d $(echo $loop_device_used | cut -d: -f1)
fi
