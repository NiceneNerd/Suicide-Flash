#!/bin/bash

function cleanup {
  scripts/cleanup.sh &> /dev/null
  rm oldsys*
}
trap cleanup EXIT

if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
	echo 'Usage: suicidepush.sh LOCALFILE REMOTEFILE'
	echo 'Uses Suicide Flash to push LOCALFILE to a phone system at REMOTEFILE.'
	echo
	echo 'Created by the Nicene Nerd, whose blog at <http://www.thenicenenerd.com/> has'
	echo 'absolutely nothing to do with Android'
	echo
	exit
elif [ ! -e $1 ]; then
	echo "Local file '$1' does not exist! Aborting."
	exit
fi

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "~~~~~~~~~~~~~~~~~~~~ Suicide Push for Moto ~~~~~~~~~~~~~~~~~~~~"
echo ~~~~~~~~~~~~~~~~~~~~~~~~ by Nicene Nerd ~~~~~~~~~~~~~~~~~~~~~~~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo Pulling system image from phone...
lsoldsys=$(adb shell ls /sdcard/oldsys.img)
if [[ $lsoldsys == *"No such file"* ]]; then
	res=$(adb root)
	if [[ $res == *"production builds"* ]]; then
		echo "Your phone must be able to run ADB as root to use this script. To correct this,"
		echo "try downloading ADB Insecure from the Play Store or XDA to enable insecure ADB."
		exit
	fi
	adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/system of=/sdcard/oldsys.img bs=1024"
fi
adb pull /sdcard/oldsys.img
if [ ! -e "oldsys.img" ]; then echo "System image not pulled! Aborting."; exit; fi
scripts/mountimg.sh oldsys.img
echo 'Copying file(s) to push...'
cp $1 "${2/\/system/mnt-oldsys\.img}"
read
echo Creating new system image...
scripts/umountimg.sh oldsys.img &> /dev/null
echo Getting system partition offset...
offset=$(scripts/getsystemoffset.sh)
echo Creating push package...
./pkgmaker.sh -m oldsys-mod.img oldsys.img "Your phone" 'N/A' $offset pushpkg.zip
if [ ! -e "output/pushpkg.zip" ]; then echo "Failed to create push package! Aborting."; exit; fi
echo Rebooting to fastboot mode...
adb reboot-bootloader
echo Flashing push package...
./suicideflash.sh -s output/pushpkg.zip
rm output/pushpkg.zip
scripts/cleanup.sh &> /dev/null
rm oldsys*