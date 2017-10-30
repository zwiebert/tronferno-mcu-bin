# tronferno-mcu-bin

MCU firmware binary for [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu).


You need an ESP8266 board with USB connector. The firmware is build for a board with 4 MByte flash.


### Usage on Windows

  * download the files
  * open command prompt and change to directory containing the flash.bat file
  * connect ESP8266 to PC via USB cable
  * find out which COM port the ESP is connected to (e.g. by device manager) 
  * run: flash.bat COMxx


### Usage on Linux

  * download the files
  * open command prompt and change to directory containing the flash.sh file
  * connect ESP8266 to PC via USB cable
  * find out which serial port the ESP is connected to (ls /dev/ttyUSB* ) 
  * (install python, if not already installed)
  * run: . flash.sh /dev/ttyUSBx


 ### Problems
  * Should only be flashed on the 4 MByte variant of ESP8266. 
  * Flash mode is set to DIO for better compatibilty (-fm dio). I bought some "integrated" boards, which will not work with -fm qio.
  
