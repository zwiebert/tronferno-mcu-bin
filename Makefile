
THIS_ROOT = ~/proj/mcu/tronferno-mcu-bin
TRONFERNO_MCU_ROOT = ./tronferno-mcu
BUILD_BASE = tmp
TRONFERNO_MCU_REPO = ~/proj/mcu/tronferno-mcu

ESP8266_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_firmware BUILD_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_build -C $(TRONFERNO_MCU_ROOT)


AVR_FW_DIR = ../../../$(BUILD_BASE)/atmega328_firmware
AVR_BUILD_DIR = $(THIS_ROOT)/$(BUILD_BASE)/atmega328_build
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(AVR_FW_DIR) BUILD_BASE=$(AVR_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)


ESP32_BUILD_DIR = ../../../$(BUILD_BASE)/esp32_build
ESP32_MK_FLAGS = DISTRO=1 BUILD_DIR_BASE=$(ESP32_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

BUILD_DIRS = $(BUILD_BASE)/esp8266_build $(BUILD_BASE)/atmega328_build
FW_DIRS = $(BUILD_BASE)/esp8266_firmware $(BUILD_BASE)/atmega328_firmware

.PHONY : all clean commit pull push distribute fetch_source esp8266 esp32 atmega328



distribute : all commit push


esp8266:  
	mkdir -p firmware/esp8266
	make  $(ESP8266_MK_FLAGS) esp8266-all
	cp -p $(BUILD_BASE)/esp8266_firmware/eagle.flash.bin $(BUILD_BASE)/esp8266_firmware/eagle.irom0text.bin ~/esp/ESP8266_NONOS_SDK/bin/esp_init_data_default_v08.bin ./firmware/esp8266/

esp32: 
	mkdir -p firmware/esp32
	make   $(ESP32_MK_FLAGS) esp32-all
	cp -p  $(BUILD_BASE)/esp32_build/bootloader/bootloader.bin  $(BUILD_BASE)/esp32_build/tronferno-mcu.bin $(BUILD_BASE)/esp32_build/partitions.bin ./firmware/esp32/

atmega328: 
	mkdir -p firmware/atmega328
	$(MAKE)  $(AVR_MK_FLAGS) atmega328-all
	cp -p $(BUILD_BASE)/atmega328_firmware/fernotron.hex $(BUILD_BASE)/atmega328_firmware/fernotron.eep ./firmware/atmega328/

all:  fetch_source esp8266 esp32 atmega328


clean:
	$(MAKE) $(ESP8266_MK_FLAGS) esp8266-clean
	$(MAKE) $(AVR_MK_FLAGS) atmega328-clean
	$(MAKE) $(ESP32_MK_FLAGS) esp32-clean

fetch_source:
	cd $(TRONFERNO_MCU_ROOT) && git checkout master && git clean -fd && git pull 

commit :
	git commit -a -m "new binaries"

pull :
	git pull

push :
	git push


