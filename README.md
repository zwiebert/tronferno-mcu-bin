# Tronferno / tronferno-mcu-bin

MCU firmware binary, tools and docs for [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu).

## Overview

  * provide all functions of a Fernotron programming central unit 2411, so it can replace it (mostly)
  * MQTT interface for easy integration with home automation servers
  * easy to flash and to configurer with interactive tool
  * ESP32 using ESP-IDF, 4MB FLASH.
  * ESP8266 using NONOS, 4MB FLASH.  (Firmware untested. No MQTT.)
  * ATMEGA328 using SDK. (Old version. Limited features. No WLAN.)

## Programming the Firmware and configure connection data

  * Run menutool (menutool.sh on Linux) from main directory.
  * Connect your esp32 or esp8266 via USB
  * Press 'i' to find the correct port
  * Press 'f' to configure chip model (esp32/esp8266) and serial port
  * If you want to erase the chip, press 'e'
  * Press 'w' to write the firmware to chip
  * Press 'c' to configure WLAN and MQTT login data
  * Press 'o' to write WLAN and MQTT login data to the chip

Alternatively there are scripts (both Linux and Windows versions) for
writing firmware.  These must be run from main directory:

  flash_esp32 SERIAL_PORT
  flash_esp8266 SERIAL_PORT
  flash_atmega328 SERIAL_PORT


## Wiring Radio transmitter (and receiver) to pins:

 * ESP32: RF_Transmitter=GPIO_17, RF_Receiver=GPIO_22

 * ESP8266: RF_Transmitter=GPIO_4 (D2), RF_Receiver=GPIO_5 (D1)

 * ATMEGA328:  RF_Transmitter=PB3 (D11), RF_Receiver=PD2 (D2)

## Sending Commands

  * the firmware provides a command line interface

  * commands can be send via USB, TCP-server or MQTT

  * commands lines are always terminated with semicolon

  * There is no echo on USB. Use local echo. Backspace key works.

  * Use command  "help all;" to show all commands and options

### MQTT

* MQTT feature in Tronferno is still under development and will change

1. Commands will be expected at MQTT topic tfmcu/cli

  * Don't terminate commands with a semicolon (like in USB-CLI)

  * Don't send multiple commands at once separated by semicolon

  * You can prepend all commands with word "cli" (gives access to all
    CLI commands). The following commands can be used without this
    prefix word: send, timer, config.  This behaviour makes thing more
    convinient in FHEM.

2. MCU-config data will be posted at MQTT topic tfmcu/config_out in JSON format

3. Timer/automatic data will be postet at MQTT topic tfmcu/timer_out in JSON format
