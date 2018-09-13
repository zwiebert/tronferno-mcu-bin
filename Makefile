

TRONFERNO_MCU_ROOT = ../tronferno-mcu
THIS_ROOT = ~/proj/mcu/tronferno-mcu-bin

ESP8266_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/.esp8266_firmware BUILD_BASE=$(THIS_ROOT)/.esp8266_build -C $(TRONFERNO_MCU_ROOT)


AVR_FW_DIR = ../../../tronferno-mcu-bin/.atmega328_firmware
AVR_BUILD_DIR = $(THIS_ROOT)/.atmega328_build
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(AVR_FW_DIR) BUILD_BASE=$(AVR_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)


ESP32_BUILD_DIR = $(TRONFERNO_MCU_ROOT)/user/esp32/build
ESP32_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/.esp32_firmware BUILD_BASE=$(THIS_ROOT)/.esp32_build -C $(TRONFERNO_MCU_ROOT)

BUILD_DIRS = .esp8266_build .atmega328_build
FW_DIRS = .esp8266_firmware .atmega328_firmware

.PHONY : all clean commit pull push distribute esp8266 esp32 atmega328


distribute : all pull commit push


esp8266:
	mkdir -p firmware/esp8266
	make -j $(ESP8266_MK_FLAGS) esp8266-all-force
	cp -p .esp8266_firmware/eagle.flash.bin .esp8266_firmware/eagle.irom0text.bin ~/esp/ESP8266_NONOS_SDK/bin/esp_init_data_default_v08.bin ./firmware/esp8266/

esp32:
	mkdir -p firmware/esp32
	make -j  $(ESP32_MK_FLAGS) esp32-all-force
	cp -p $(ESP32_BUILD_DIR)/bootloader/bootloader.bin $(ESP32_BUILD_DIR)/tronferno-mcu.bin $(ESP32_BUILD_DIR)/partitions.bin ./firmware/esp32/

atmega328:
	mkdir -p firmware/atmega328
	$(MAKE) -j  $(AVR_MK_FLAGS) atmega328-all-force
	cp -p .atmega328_firmware/fernotron.hex .atmega328_firmware/fernotron.eep ./firmware/atmega328/

all: esp8266 esp32 atmega328


clean:
	$(MAKE) $(ESP8266_MK_FLAGS) esp8266-clean
	$(MAKE) $(AVR_MK_FLAGS) atmega328-clean


commit :
	git commit -a -m "new binaries"

pull :
	git pull

push :
	git push


