@echo usage:  flash.bat COMx


set comport=%1

tools\esptool.exe --chip esp8266 -p "%comport%" write_flash -ff 40m -fm dio -fs 4MB 0x00000 firmware/esp8266/eagle.flash.bin 0x10000 firmware/esp8266/eagle.irom0text.bin  0x3FC000 firmware/esp8266/esp_init_data_default_v08.bin 0x3FE000 firmware/esp8266/blank.bin

