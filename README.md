# tronferno-mcu-bin

[----> Lese in Deutsch](README-de.md)

------------------------

## Overview

  This repository contains ESP32 Firmware images of tronferno-mcu and also tools for flashing on Linux and Windows.
  
  Tronferno is a firmware to control and program Fernotron devices (window blinds). The web interface replaces the original programming centre. Home server can be connected via MQTT. Configurations for some home servers can bre generated automatically.
  

## Flashing and Network Connectivity

  Use the small interactive self-explaining command line Programm (Windows: menutool.cmd, Linux menutool.sh). It does the flashing, configuration of WLAN connection, and then displays the URL to the web interface.
  
## First steps

  You may complete the Hardware first, so you can send RF signals to the Fernotron receivers. Or you start with a naked ESP32-board and install just the firmware, configure the web interface and make the home-server work with it. Instead of real moving windows shutters, you will see moving sliders in the user interface
  until you add an RF module later.

## More Information
  
   * Read the [Quick-Start Guide](docs/starter-de.md)
   
   * Get the source code at repository [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu)

   * You can read [menutool manual](docs/menutool.md) if you run into problems while using it.  

   
