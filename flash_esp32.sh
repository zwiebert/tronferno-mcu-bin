#!/bin/sh


fwdir=firmware/esp32

comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash_esp32.sh /dev/ttyUSBx"  
else

python tools/esptool.py --chip esp32 --port $comport  --baud 230400 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect \
       0x1000 $fwdir/bootloader.bin \
       0x10000 $fwdir/tronferno-mcu.bin \
       0x8000 $fwdir/partitions.bin
fi
