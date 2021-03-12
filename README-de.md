# tronferno-mcu-bin

[---> Read in English](README.md)

## Overview

  Tronferno ist eine Mikrocontroller-Firmware zum Steuern von Fernotron Geräten (idR Rollläden).
  Das Ziel ist die komplette Funktionalität der originalen Programmierzentrale, und mehr, zu implementieren.  Aber auch einfach das komforatable Steuern der Grundfunktionen wie Auf und Zu.
  
  Dieses Repository enhält die Firmware-Binaries und die zum Flashen notwendigen Programme und Information. 
  
  
## Weitere Information
  
   * Lies die [Schnellstart-Anleitung](docs/starter-de.md)
   
   * Finde den Quell-Code im Repository [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu)
   
  
## Inkompatible Änderungen

   * 2021-03 - OTA-Firmware-Update (über Web-Browser): Mit der neuesten Entwicklungsumgebung stieg die Größe der Firmware-Datei über 1MB. Dadurch lassen sich ESP32 module die vor April 2020 das letzte mal über USB geflasht wurden nicht mehr per OTA/Webbrowser) updaten.  Ein einmaliges Firmware-Update über USB (z.B. menutool oder FHEM Modul TronfernoMCU) behebt das Problem.