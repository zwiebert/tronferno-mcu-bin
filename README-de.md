# tronferno-mcu-bin

[---> Read in English](README.md)

## Overview

  Tronferno ist eine Mikrocontroller-Firmware zum Steuern und Konfigurieren von Fernotron Geräten (Rollläden).
  
  Die Web-Oberfläche ersetzt dabei auch die Funktionen der originalen Programmierzentrale.
  
  Konfigurationen für einige HomeServer werden automatisch erstellt.
  
  
  Dieses Repository enhält die Firmware-Binaries und die zum Flashen notwendigen Werkzeuge und Anleitungen. 
  
  
## Weitere Information
  
   * Lies die [Schnellstart-Anleitung](docs/starter-de.md)

   * Lies die [Anleitung zum Flashen mit menutool](docs/menutool-de.md)
      
   * Finde den Quell-Code im Repository [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu)
   
  
## Inkompatible Änderungen

   * 2021-03 - OTA-Firmware-Update (über Web-Browser): Mit der neuesten Entwicklungsumgebung stieg die Größe der Firmware-Datei über 1MB. Dadurch lassen sich ESP32 module die vor April 2020 das letzte mal über USB geflasht wurden nicht mehr per OTA/Webbrowser updaten.  Ein einmaliges Firmware-Update über USB (z.B. menutool oder FHEM Modul TronfernoMCU) behebt das Problem.