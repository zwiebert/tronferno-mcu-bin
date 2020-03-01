# Tronferno / tronferno-mcu-bin

MCU firmware binary, tools and docs for [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu).

## Overview

  Tronferno is a firmware to turn an ESP32 MCU board into an hardware dongle
  to control Fernotron devices (usually shutters).

  It aims to provide all functionality of the original programming central 2411,
  but it also can do just plain up/down/stop commands, if you want just that.

  * Command interfaces: USB, TCP, MQTT, HTTP
  * Supported by FHEM home server via specific module for USB connection
  * Can be integrated into homer servers via its MQTT interface

## Required Hardware

  * ESP32, 4MB FLASH. (current main hardware for further development)
  * ESP8266, 4MB FLASH. (deprecated, no MQTT support for now(?))
  * ATMEGA328. (outdated firmware with limited features. No WLAN.)

## Programming the Firmware and configure connection data

The app [menutool](docs/menutool.md) can be used to flash the firmware and do the basic configuration.

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

See [docs/hardware](docs/hardware.md)


## Plain old Commandline Interface
  * CLI can be used via USB-Terminal or WiFi-Terminal at TCP Port 7777

  * commands are terminated with semicolon. A newline is not required.

  * Use local echo

  * Backspace key can be used.

  * Use command  "help all;" to show all commands and options

  * command lines can also be sent in JSON format
```
       {"name":"tfmcu", "config":{ "verbose":4, "http-enable":1 }}
```

  * See [config](docs/mcu_config.md), [CLI](docs/CLI.md)

### HTTP

* A builtin web server to configure options and control/program shutters

* This feature in Tronferno is new and still under development. It
  will change. It may only work in beta-branch firmware.


* After gaining WIFI/WLAN access by using menutool, you can acces the
  MCU by entering the IP4-address of the ESP32 into a web browser
  (javascript needs to be enabled)
  
* see [network](docs/network.md), [HTTP](docs/http.md), [webserver](docs/webserver.md)

### MQTT

* MQTT feature in Tronferno is new and still under development. It
  will change.  It may only work in beta-branch firmware.

 * see [MQTT](docs/mqtt.md)