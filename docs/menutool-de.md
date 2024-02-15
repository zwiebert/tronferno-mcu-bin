### tronferno-menutool

  * Das Tool dient zum interaktiven Flashen der Firmware und zum Konfigurieren der WLAN Verbindung
  
  1. Starte menutool (./menutool.sh auf Linux, .\menutool.cmd auf Windows) vom aupt-Verzeichnis.
     Es öffnet sich ein Menü das über Buchstaben-Tasten gesteuert wird.

```

Press [key] to choose menu item:


   Save Progress / Quitting:
    [s] Save your changes (e.g. serial port, MCU pre-configuration)
    [X] Exit this program  (unsaved data will be lost)

1) Connect to the Microcontroller:
    [i] Find connected chips and print info
    [p] Choose the connected USB/COM port
    [I] Print info about chip esp32@/dev/ttyUSB1
    [f] If needed: configure some more flash options

2) Flash the Microcontroller:
    [e] Erase flash (esp32@/dev/ttyUSB1). Usually not needed. Clears any data and firmware.
    [w] Write firmware to flash (esp32@/dev/ttyUSB1).
3) Connect the Microncontroller to WIFI
    [c] Configure tronferno-mcu options like WLAN and MQTT login data
    [o] Write tronferno-mcu options to chip via serial port (do this *after* flashing the firwmware)

4) Access the builtin webserver: IP-Address: 0.0.0.0, Hostname: tronferno
    [a] Get IP address from chip
   URLs: http://0.0.0.0 -or- http://tronferno.fritz.box

```
  1)
     * Schließe Mikrocontroller über USB an
     * Drücke 'i' zum Ausprobieren welcher COM/USB-Port der richtige ist
     * Drücke 'f' zur Konfiguration
  
 Hinweis: Unter Windows kann es nötig sein den virtual-com-port Treiber für den auf dem Board verbauten
          USB-Chip downzuloaden. Öffne Windows-DeviceManager um den Chip zu identifizieren. 
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
  2)
    * Wenn du den Flash Speicher total löschen möchtest, dann 'e' drücken.
    * Zum flashen der Firmware, 'w' drücken.
    * Drücke 'c' zur Konfiguration von WLAN und HTTP
```
Press key to choose menu item:

 [y] apply changes and leave menu
 [X] discard changes and leave menu

 [a] wlan-password (xxx)
 [b] wlan-ssid (xxx)
 [c] http-enable (1)
 [d] http-user ()
 [e] http-password ()
 [f] mqtt-enable (1)
 [g] mqtt-url (mqtt://192.168.1.42:7777)
 [h] mqtt-user ()
 [i] mqtt-password ()

```
  3)
   Drücke 'o' to write WLAN and MQTT login data to the chip. 
  
  4)
   Drücke 'a' zu auslesen der IP adresse from the microcontroller and use a webrowser to connect to it.
   