#!/bin/bash

function cleanup {
  scripts/cleanup.sh
}
trap cleanup EXIT

if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]
 then
	echo 'Usage: pkgmaker.sh [OPTION]... ORIGINALSYSTEM TARGETDEVICE REQUIREMENTS'
	echo '  SYSTEMOFFSET OUTPUTFILE'
	echo 'Creates a Suicide Flash package for writing to Moto phones via the emergency'
	echo 'Qualcomm download mode.'
	echo
	echo 'Arguments:'
	echo '  ORIGINALSYSTEM     provides the original system image to be modded'
	echo '                     can use value "ADB" to pull the system image over ADB'
	echo '  TARGETDEVICE       specifies the model of phone for the package to flash'
	echo '  REQUIREMENTS       notes any important requirements for the phone state'
	echo '                     prior to flashing'
	echo '                     examples: "Stock", "Rooted", or "Rooted+Xposed"'
	echo '  SYSTEMOFFSET       the address of the system partition on the target device'
	echo '                     should be in hex format (i.e. 0x6420000 or 6420000)'
	echo '                     can use value "ADB" to pull the offset over ABD'
	echo '  OUTPUTFILE         the name of the Suicide Flash zip package to be created'
	echo
	echo 'Options:'
	echo '  -h, --help         returns this help message'
	echo '  -m MODDEDSYSTEM    specifies an existing modded system image'
	echo '                     if not given, will mount original for modification'
	echo 
	echo 'Created by the Nicene Nerd, whose blog at <http://www.thenicenenerd.com/> has'
	echo 'absolutely nothing to do with Android'
	echo
	exit
fi

if [ $1 == "-m" ]; then
	newimg=$2
	oldimg=$3
	target=$4
	req=$5
	ofst=$6
	pkgname=$7
else
	oldimg=$1
	target=$2
	req=$3
	ofst=$4
	pkgname=$5
fi

if [ ! -z $newimg ] && [ ! -e $newimg ]; then
	echo "Modified system image '$newimg' does not exist! Aborting."
	exit
fi

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~~~~ Suicide Flash Package Maker ~~~~~
echo ~~~~~~~~~~~ by Nicene Nerd ~~~~~~~~~~~~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 
echo Cleaning any leftovers before starting...
scripts/cleanup.sh &> /dev/null
if [[ $oldimg == "ADB" ]]; then
	res=$(adb root)
	if [[ $res == *"production builds"* ]]; then
		echo "Your phone must be able to run ADB as root to use this script. To correct this,"
		echo "try downloading ADB Insecure from the Play Store or XDA to enable insecure ADB."
		exit
	fi
	adb pull /dev/block/platform/msm_sdcc.1/by-name/system oldsys.img
	$oldimg="oldsys.img"
fi

if [ ! -e $oldimg ] then
	echo "System image '$oldimg' is missing! Aborting."
	exit
fi

if [ -z $newimg ]
 then
	scripts/mountimg.sh $oldimg
	echo
	echo "Your original system image is mounted at mnt-$oldimg. As root user, modify any files"
	echo "you need then press any key to continue."
	read

	echo Unmounting system image...
	scripts/umountimg.sh $oldimg &> /dev/null
	newimg=${oldimg%.img}-mod.img
fi

if [ ! -e $newimg ]; then
	echo "Modified system image '$newimg' is missing! Aborting."
	exit
fi

mkdir _tmp
echo 
scripts/imgdiff.sh 1024 $newimg $oldimg _tmp
echo Pulling bootloader files...
res=$(adb root)
if [[ $res == *"production builds"* ]]; then
	echo "Your phone must be able to run ADB as root to use this script. To correct this,"
	echo "try downloading ADB Insecure from the Play Store or XDA to enable insecure ADB."
	exit
fi
adb pull /dev/block/platform/msm_sdcc.1/by-name/sbl1 _tmp/sbl1.mbn
adb pull /dev/block/platform/msm_sdcc.1/by-name/sbl2 _tmp/sbl2.mbn

if [ ! -e "sbl1.mbn" ] || [ ! -e "sbl1.mbn"]; then
	echo "Bootloader images not pulled! Aborting."
	exit
fi

echo 
echo Creating requirements file...
echo $target > _tmp/requirements.txt
echo $req >> _tmp/requirements.txt
if [ $ofst == "ADB" ]; then
	ofst=$(scripts/getsystemoffset.sh)
fi
echo $ofst >> _tmp/requirements.txt
echo Zipping package...
if [ ! -e output ]; then mkdir output; fi
cd _tmp
zip ../output/$pkgname * &> /dev/null
cd ../
echo Cleaning up...
scripts/cleanup.sh &> /dev/null
chmod -R 777 *
echo All done! Happy flashing!
