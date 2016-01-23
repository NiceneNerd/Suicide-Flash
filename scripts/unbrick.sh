#!/bin/bash

if [ ! -e scripts ]
 then 
	cd ../
fi

usbls=$(lsusb 2>/dev/null)
while [[ $usbls != *"Qualcomm"* ]]; do
	echo Cannot find phone in Qualcomm emergency download mode!
	echo Enter R to retry, or Q to quit.
	read resp
	if [ $resp == "Q" ]; then scripts/cleanup.sh && exit; fi
done;
echo Unbricking...
python files/qdloadSBL.py files/MPRG8960.bin -ptf files/partTemplate.txt
echo The Python script finished executing. I hope there were no errors. If so, enjoy!