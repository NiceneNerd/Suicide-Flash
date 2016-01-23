adb root &> /dev/null
adb push files/parted /data/local/tmp/parted &> /dev/null
adb shell chmod 777 /data/local/tmp/parted &> /dev/null
adb shell '/data/local/tmp/parted /dev/block/mmcblk0 unit B print' |
while IFS= read -r line; do
	if [[ $line == *"  system"* ]]; then
		sys=${line:8}
		sys=${sys//B*system}
		sys=$(tr -dc '[[:print:]]' <<< "$sys")
		echo "obase=16; $sys" | bc > .offset
	fi
done
echo "0x$(cat .offset)"
rm .offset