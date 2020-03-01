
  * here you can flash the firmware and configure at least the
    WIFI/WLAN login data. The reimaing configurain can be done in a
    web browser. (see HTTP)

  1. Run menutool (menutool.sh on Linux) from main directory.
  It will give you a text based menu.

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
  7. Press 'c' to configure WLAN, HTTP and MQTT login data. (Note: MQTT can also be configured later from Web-Interface, once WLAN is configured and HTTP enabled)
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
  8. Press 'o' to write WLAN and MQTT login data to the chip
