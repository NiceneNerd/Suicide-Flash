#!/bin/bash

if [ ! -e scripts ]
 then 
	cd ../
fi
 
rm -Rf newsys & rm -Rf oldsys & rm -f _root/system* & rm -Rf _tmp & rm -f *.vdi & rm -f tmpfile.zip & rm -f *_tmp* &> /dev/null
rm mnt-*.img &> /dev/null
qemu-nbd -d /dev/nbd0 &> /dev/null