#!/bin/sh


fwdir=firmware/esp8266

comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash.sh /dev/ttyUSBx"  
else

    python tools/esptool.py --chip esp8266 -p "$comport"  write_flash -ff 40m -fm dio -fs 4MB \
	   0x00000 $fwdir/eagle.flash.bin \
	   0x10000 $fwdir/eagle.irom0text.bin \
	   0x3FC000 $fwdir/esp_init_data_default_v08.bin \
	   0x3FE000 $fwdir/blank.bin

fi
