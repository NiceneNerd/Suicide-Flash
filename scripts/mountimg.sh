#!/bin/bash

if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
	echo 'Usage: mountimg.sh SYSTEMIMG'
	echo 'Mounts otherwise unmountable Moto system images for modding by converting to VDI'
	echo 'and using qemu-ndb.'
	echo
	echo 'Created by the Nicene Nerd, whose blog at <http://www.thenicenenerd.com/> has'
	echo 'absolutely nothing to do with Android'
	echo
	exit
elif [ ! -e $1 ]; then
	echo "System image '$1' does not exist! Aborting."
	exit
fi

if [ ! -e scripts ]
 then 
	cd ../
fi
if [ ! -f $1.vdi ]
 then
	echo Converting system image to VDI...
	VBoxManage convertfromraw --format VDI $1 $1.vdi
fi
chmod 777 *
echo Mounting system image...
modprobe nbd
qemu-nbd -c /dev/nbd0 $1.vdi
mkdir mnt-$1
mount -o rw /dev/nbd0 mnt-$1
md5=($(md5sum $1.vdi))
echo $md5 > .checksum
