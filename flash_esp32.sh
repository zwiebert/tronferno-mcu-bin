#!/bin/sh
part_ota0=0x100000
part_ota_init=0x10000


fwdir=firmware/esp32

comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash_esp32.sh /dev/ttyUSBx"
else


    python tools/esptool.py --chip esp32 --port $comport  --baud 230400 \
	   --before default_reset --after hard_reset \
	   write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect \
        0x1000 $fwdir/bootloader.bin \
        0x8000 $fwdir/partitions.bin \
       $part_ota0 $fwdir/tronferno-mcu.bin \
       $part_ota_init $fwdir/ota_data_initial.bin


fi
