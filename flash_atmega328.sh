#!/bin/sh

comport=$1

if [ $# -ne 1 ]
then
    echo "usage: . flash.sh /dev/ttyACMx"  
else
    

COM=/dev/ttyACM0
#comport=$COM
hex_out=./firmware/fernotron.hex
eep_out=./firmware/fernotron.eep


avrdude  -c avrisp2 -p m328p -P "$comport" -b 115200 -U "flash:w:$hex_out:i"
avrdude  -c avrisp2 -p m328p -P "$comport" -b 115200 -U "eeprom:w:$eep_out:i"

fi
