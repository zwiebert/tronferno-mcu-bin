# Tronferno / tronferno-mcu-bin

MCU firmware binary, tools and docs for [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu).

## Overview

  Tronferno is a firmware to turn an ESP32 MCU board into an hardware dongle
  to control Fernotron devices (usually shutters).
   
  It aims to provide all functionality of the original programming central 2411, 
  but it also can do just plain up/down/stop commands, if you want just that.
  
  * Command interfaces: USB, TCP, MQTT
  * Supported by FHEM home server via specific module for USB connection
  * Can be integrated into homer servers via its MQTT interface

## Required Hardware

  * ESP32, 4MB FLASH. (current main hardware for further development)
  * ESP8266, 4MB FLASH. (deprecated, no MQTT support for now(?))
  * ATMEGA328. (outdated firmware with limited features. No WLAN.)

## Programming the Firmware and configure connection data

  1. Run menutool (menutool.sh on Linux) from main directory. 
  It will give you an text based menu.
  
  ```
Press key to choose menu item:

 [q] save config data to file and quit
 [X] discard config data and quit
 [s] save configuration data but don't quit

 [i] find connected chips and print info
 [I] print info on chip at /dev/ttyUSB0
 [f] configure flash options like serial-port, chip-type, etc
 [w] write flash (esp8266@/dev/ttyUSB0). Writes the firmware
 [e] erase flash (esp8266@/dev/ttyUSB0). Usually not needed. Clears any data and firmware.

 [c] configure tronferno-mcu options like WLAN and MQTT login data
 [o] write tronferno-mcu options to chip via serial port (do this *after* flashing the firwmware)

Shortcuts:
 [p] change serial port (/dev/ttyUSB0)
   
  ```
  2. Connect your esp32 or esp8266 via USB
  3. Press 'i' to find the correct port
  4. Press 'f' to configure chip model (esp32/esp8266) and serial port
  ```
Press key to choose menu item:

 [y] apply changes and leave menu
 [X] discard changes and leave menu

 [a] chip (esp8266)
 [b] flash-size (detect)
 [c] serial-baud (115200)
 [d] serial-port (/dev/ttyUSB0)

Enter value for chip (esp8266): ...esp32
   
  ```
  5. If you want to erase the chip, press 'e'
  6. Press 'w' to write the firmware to chip
  7. Press 'c' to configure WLAN and MQTT login data
  ```
Press key to choose menu item:

 [y] apply changes and leave menu
 [X] discard changes and leave menu

 [a] wlan-ssid (xxxx)
 [b] mqtt-user (xxxx)
 [c] mqtt-enable (1)
 [d] mqtt-url (mqtt://192.168.1.42:7777)
 [e] wlan-password (xxxx)
 [f] mqtt-password (xxxx)

 
  ```
  8. Press 'o' to write WLAN and MQTT login data to the chip

Alternatively there are scripts (both Linux and Windows versions) for
writing firmware.  These must be run from main directory:
```
  ~/tronferno-mcu-bin$ sh ./flash_esp32.sh /dev/ttyUSB0
 ```
 ``` 
  C:\tronferno-mcu-bin> flash_esp8266 COM3
```
```  
  ~/tronferno-mcu-bin$ sh ./flash_atmega328.sh /dev/ttyACM0
```

## Wiring Radio transmitter (and receiver) to pins:

 * ESP32: RF-Transmitter=GPIO_17, RF-Receiver=GPIO_22

 * ESP8266: RF-Transmitter=GPIO_4 (D2), RF-Receiver=GPIO_5 (D1)

 * ATMEGA328:  RF-Transmitter=PB3 (D11), RF-Receiver=PD2 (D2)


## Plain old Commandline Interface
  * CLI can be used via USB-Terminal or WiFi-Terminal at TCP Port 7777

  * commands are terminated with semicolon. A newline is not required.

  * Use local echo
  
  * Backspace key can be used.

  * Use command  "help all;" to show all commands and options
  

### MQTT

* MQTT feature in Tronferno is new and still under development. It will  change.

* Commands will be expected at MQTT topic tfmcu/cli

    * Don't terminate commands with a semicolon (like in USB-CLI)

    * Don't send multiple commands at once separated by semicolon

    * You can prepend all commands with the word "cli". This gives access to all
    CLI commands. Only the commands send, timer, config can be used without the cli prefix.


* MCU-config data will be posted at MQTT topic tfmcu/config_out in JSON format

* Timer/automatic data will be postet at MQTT topic tfmcu/timer_out in JSON format
