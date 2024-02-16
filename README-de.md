# tronferno-mcu-bin

[---> Read in English](README.md)

## Übersicht

  Dieses Repository enhält die Firmware-Binaries von tronfenro-mcu und Programme zum Flashen unter Linux und Windows

  Tronferno ist eine Mikrocontroller-Firmware zum Steuern und Konfigurieren von Fernotron Geräten (Rollläden). Die Web-Oberfläche ersetzt dabei auch die Funktionen der originalen Programmierzentrale. Homeserver werden per MQTT angebunden. Konfigurationen für einige HomeServer werden automatisch erstellt.

## Flashen und Netzwerkverbindung

  Ein selbsterklärendes interaktives Programm für Kommandozeile (Windows: menutool.cmd, Linux menutool.sh) übernimmt das Flashen, das Einrichten des WLAN und die Anzeige der URL zum öffnen der Weboberfläche.

## Erste Schritte

  Entweder du baust die Hardwware so weit zusammen, dass Funksignale gesendet werden können. Oder du startest mit einem nackten ESP32 Board und bringst Weboberfläche und Homeserveranbindung zum Laufen, auch wenn sich dann bis zum Hinzufügen des Funksende-Moduls nur Slider im Browser bewegen, statt der Rollläden.


## Weitere Information
  
   * Lies die [Schnellstart-Anleitung](docs/starter-de.md)

   * Wenn Probleme mit menutool auftreten, lies die [Menutool Anleitung](docs/menutool-de.md)
      
   * Finde den Quell-Code im Repository [tronferno-mcu](https://github.com/zwiebert/tronferno-mcu)
   
  
