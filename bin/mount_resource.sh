#!/bin/bash -x
resource_name=$1
resource_path=$2
mount_point=$3
if [[ ! -e "${resource_path}" ]]; then
    >&2 echo "Not mounted? Missing: ${resource_path}"
    exit 1
fi
if [[ ! -e "${mount_point}" ]]; then
    sudo mkdir -p ${mount_point}
    sudo chown $(id -u):$(id -g) ${mount_point}
else
    if [[ "$(ls -A ${mount_point})" ]]; then
	>&2 echo "Not-empty: ${mount_point}"
	exit 1
    fi
fi

echo "Mounting $resource_name"
if [[ -b $resource_path ]]; then
    using_loop=0
    loopdev=$resource_path
else
    using_loop=1
    loopdev=$(sudo losetup -f)
    sudo losetup $loopdev $resource_path
fi
set +x
sudo echo  # make sure sudo password is cached before pipe
echo $(supergenpass.sh $resource_name 24) | sudo cryptsetup -c aes-xts-plain create --allow-discards $resource_name $loopdev
if [[ $? -ne 0 ]]; then
    set -x
    if [[ $using_loop == 1 ]]; then
	sudo losetup -d $loopdev
    fi
    exit 1
fi
set -x
#sudo mkfs.btrfs /dev/mapper/$resource_name
sudo mount $4 /dev/mapper/$resource_name $mount_point
if [[ $? -ne 0 ]]; then
    sudo cryptsetup remove $resource_name
    if [[ $using_loop == 1 ]]; then
	sudo losetup -d $loopdev
    fi
    exit 1
fi
