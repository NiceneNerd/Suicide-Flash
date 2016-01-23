#!/bin/bash

if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
	echo 'Usage: umountimg.sh SYSTEMIMG'
	echo '  or:  umountimg.sh SYSTEMIMG OUTPUTIMG'
	echo 'Unmounts Moto system images that have been mounted with mountimg.sh and outputs'
	echo 'a modded raw IMG if changes have been made.'
	echo
	echo 'Created by the Nicene Nerd, whose blog at <http://www.thenicenenerd.com/> has'
	echo 'absolutely nothing to do with Android'
	echo
	exit
fi

if [ ! -e scripts ]
 then 
	cd ../
fi

md5=($(md5sum $1.vdi))
origmd5=($(cat .checksum))
umount mnt-$1
rmdir mnt-$1
qemu-nbd -d /dev/nbd0
if [ $md5 != $origmd5 ]; then
	echo Detected changes to system VDI. Creating modified raw image...
	if [ ! -z $2 ]; then
		mdfile=$2
	else
		modfile=${1%.img}
		mdfile=$modfile-mod.img
	fi
	VBoxManage internalcommands converttoraw $1.vdi $mdfile &> /dev/null
fi
chmod 777 *
rm .checksum
rm $1.vdi
