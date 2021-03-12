# tronferno-mcu-bin

[----> Lese in Deutsch](README-de.md)

------------------------

## Overview

  Tronferno is a firmware to turn an ESP32 MCU board into an hardware dongle
  to control Fernotron devices (usually shutters). It aims to provide all functionality of the original programming central 2411,
  but it also can do just plain up/down/stop commands, if you want just that.
  
  This repository contains the microcontroller-firmware and the tools needed to flash it onto your ESP32 board.
  
  The source code repository is .
  
  
## More Information
  
   * Read the [Quick-Start Guide](docs/starter-de.md)
   
   * Get the source code at repository [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu)

   
## Breaking Changes

   * 2021-03 - OTA-Firmware-Update (by web-browser): Updating the developing environment (ESP-IDF) lead to increased firmware size. This will break OTA-updates on ESP32 modules who where last flashed by USB before April 2020.  These need to be updated now once by USB (e.g. with menutool or by FHEM module TronfernoMCU).