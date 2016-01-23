#!/bin/bash

function cleanup {
  scripts/cleanup.sh
}
trap cleanup EXIT

pkg=$1
silent=false
if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
	echo 'Usage: suicideflash.sh PACKAGE'
	echo 'Flashes PACKAGE to the system parition of a Moto phone using Qualcomm'
	echo 'emergency download mode.'
	echo
	echo 'Options:'
	echo '  -h, --help      displays this help message'
	echo '  -s, --skip      skips all prompts and runs without user interaction'
	echo
	echo 'Created by the Nicene Nerd, whose blog at <http://www.thenicenenerd.com/> has'
	echo 'absolutely nothing to do with Android'
	echo
	exit
elif [ $1 == "--skip" ] || [ $1 == "-s" ]; then
	pkg=$2
	silent=true
elif [ ! -e $1 ]; then
	echo "Package '$1' does not exist! Aborting."
	exit
fi

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo '~~~~~~~~~~~~ Suicide Flash for Moto ~~~~~~~~~~~~'
echo ~~~~~~~~~~~~~~~~ by Nicene Nerd ~~~~~~~~~~~~~~~~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo 'DISCLAIMER: This is obviously a dangerous tool. I mean, it flashes your phone by'
echo 'bricking it first. Be smart. I shan'"'"'t be held responsible if your phone melts,'
echo 'explodes, loses all of its data, or cheats on you with a hula dancer.'
echo
echo Extracting flash package...
cp $pkg ./tmpfile.zip
mkdir _tmp
unzip tmpfile.zip -d _tmp/ &> /dev/null
readarray -t req < _tmp/requirements.txt
if [ $silent != true ]; then
	echo "This Suicide Flash package is designed for the ${req[0]}. It also specifies the"
	echo "following requirements:"
	echo "${req[1]}"
	echo "If you are certain your phone is an ${req[0]} and meets these requirements, press"
	echo "any key to continue, or press Ctrl-C to exit."
	read
fi
echo Preparing flash scripts...
scripts/updatescripts.sh _tmp ${req[2]}
echo 
if [ $silent != true ]; then
	echo "The package is ready to be flashed to your device. Once you begin the flash, you"
	echo "cannot cancel. In order to begin, put your phone in fastboot mode. Press any key"
	echo "to continue, or Ctrl-C to exit."
	echo 
	read
fi
fbls=$(fastboot devices 2>/dev/null)
while [[ -z $fbls ]]; do
	echo Cannot find phone in fastboot mode!
	echo Enter R to retry, or Q to quit.
	read resp
	if [ $resp == "Q" ]; then scripts/cleanup.sh && exit; fi
	fbls=$(fastboot devices 2>/dev/null)
done;
echo Found phone in fastboot mode...
echo Soft-bricking phone...
fastboot flash sbl2 files/badsbl2.mbn && fastboot reboot &> /dev/null
sleep 2
usbls=$(lsusb 2>/dev/null)
while [[ $usbls != *"Qualcomm"* ]]; do
	echo Cannot find phone in Qualcomm emergency download mode!
	echo Enter R to retry, or Q to quit.
	read resp
	if [ $resp == "Q" ]; then scripts/cleanup.sh && exit; fi
	usbls=$(lsusb 2>/dev/null)
done;
echo Found phone in emergency download mode...
echo Flashing...
python qdloadRoot_tmp.py files/MPRG8960.bin -ptf _tmp/partitions.txt
echo The Python script finished executing. I hope there were no errors. If so, enjoy!
scripts/cleanup.sh
