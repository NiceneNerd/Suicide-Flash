#!/bin/bash

if [ -z $1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
	echo 'Usage: imgdiff.sh SPLITSIZE MODDEDIMAGE ORIGINALIMAGE'
	echo '  or:  imgdiff.sh SPLITSIZE MODDEDIMAGE ORIGINALIMAGE OUTPUTDIR'
	echo 'Splits ORIGINALIMAGE and MODDEDIMAGE into chunks of size SPLITSIZE, and outputs'
	echo 'the chunks which differ between them.'
	echo 
	echo 'Arguments:'
	echo '  SPLITSIZE        size to split the system images into in kB'
	echo '  MODDEDIMAGE      the modified system image'
	echo '  ORIGINALIMAGE    the original system image'
	echo '  OUTPUTDIR        optional: the directory in which to place the modded files'
	echo '                   if not given, will output to _root/'
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
outputDir=_root
if [ ! -z $4 ]
 then
	outputDir=$4
fi
mkdir newsys
mkdir oldsys
echo Splitting new system image...
split -a 6 -d -b $(($1*1024)) $2 newsys/system --numeric=1 --additional-suffix=.mbn &> /dev/null
echo Splitting original system image...
split -a 6 -d -b $(($1*1024)) $3 oldsys/system --numeric=1 --additional-suffix=.mbn &> /dev/null
echo Outputting modified system chunks...
cd newsys
rsync -rcC --compare-dest=../oldsys . ../$outputDir/
cd ../
chmod -R 777 *
