### tronferno-menutool

  * The tool lets you flash the firmware and aids in configuring the WIFI connection.
  
  1. Start menutool (./menutool.sh on Linux, .\menutool.cmd on Windows) from main directory.
  It will show you a text based menu.

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
     * Connect the microcontroller via USB
     * Press 'i' to find the correct port
     * Press 'f' to configure the serial port
  
 Hint: On Windows, you may need to install the virtual com-port-driver for the specific USB chip used on the microcontroller board.
       Use Windows-DeviceManager to find out which driver you need.
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
    * If you want to erase the chip, press 'e'
    * Press 'w' to write the firmware to chip
    * Press 'c' to configure WLAN, HTTP and MQTT login data. (Note: MQTT can also be configured later from Web-Interface, once WLAN is configured and HTTP enabled)
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
 [h] mqtt-user (xxx)
 [i] mqtt-password (xxx)

```
  3)
   Press 'o' to write WLAN and MQTT login data to the chip. 
  
  4)
   Press 'a' to read the IP address from the microcontroller and use a webrowser to connect to it.
   