#!/bin/bash

outputfile=sysimg.img
if [ ! -z $1 ]
 then
	outputfile=$1
fi
res=$(adb root)
if [[ $res == *"production builds"* ]]; then
	echo "Your phone must be able to run ADB as root to use this script. To correct this,"
	echo "try downloading ADB Insecure from the Play Store or XDA to enable insecure ADB."
	exit
fi
adb shell "dd if=/dev/block/platform/msm_sdcc.1/by-name/system of=/sdcard/$outputfile bs=1024"
adb pull /sdcard/$outputfile
#adb shell "rm /sdcard/$outputfile"
