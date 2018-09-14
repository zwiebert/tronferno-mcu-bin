#!/bin/sh
@echo usage:  flash.bat COMx


set comport=%1

hex_out=./firmware/atmega328/fernotron.hex
eep_out=./firmware/atmega328/fernotron.eep


avrdude  -c avrisp2 -p m328p -P "%comport%" -b 115200 -U "flash:w:$hex_out:i"
avrdude  -c avrisp2 -p m328p -P "%comport%" -b 115200 -U "eeprom:w:$eep_out:i"
