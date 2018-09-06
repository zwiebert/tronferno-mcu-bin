#!/bin/sh




comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash.sh /dev/ttyUSBx"  
else

python tools/esptool.py -p "$comport"  write_flash -ff 40m -fm dio -fs 4MB 0x00000 firmware/eagle.flash.bin 0x10000 firmware/eagle.irom0text.bin  0x3FC000 firmware/esp_init_data_default_v08.bin 0x3FE000 firmware/blank.bin

fi
