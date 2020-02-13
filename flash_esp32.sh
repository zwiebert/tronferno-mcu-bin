#!/bin/sh


fwdir=firmware/esp32

comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash_esp32.sh /dev/ttyUSBx"
else

#if downloaded by FHEM module ota_data image may be missing. Just flash firmware on both OTA partitions then
FILE="$fwdir/ota_data_initial.bin"
if [ -f "$FILE" ]; then
    ota_data_initial="0x300000 $fwdir/ota_data_initial.bin"
else
    ota_data_initial="0x200000 $fwdir/tronferno-mcu.bin"
fi


    python tools/esptool.py --chip esp32 --port $comport  --baud 230400 \
	   --before default_reset --after hard_reset \
	   write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect \
        0x1000 $fwdir/bootloader.bin \
        0x8000 $fwdir/partitions.bin \
       0x10000 $fwdir/tronferno-mcu.bin \
        $ota_data_initial

fi
