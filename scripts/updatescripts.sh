#!/bin/bash

if [ ! -e scripts ]
 then 
	cd ../
fi
rt=$1
cp files/partTemplate.txt $rt/partitions.txt
cd $rt
flst=$(ls sys*)
cd ../
szs=$(wc -c $rt/system000001.mbn)
IFS=' ' read -a sz <<< "$szs"
echo Updating text partitions list...
rhino scripts/partnames.js ptf $2 ${sz[0]} $flst >> $rt/partitions.txt
pls=$(rhino scripts/partnames.js ptl $flst)
echo Updating Python parition array...
cp files/qdloadTemplate.py qdloadRoot$rt.py
sed -i "s/%%PARTITIONS%%/$pls/g" qdloadRoot$rt.py
