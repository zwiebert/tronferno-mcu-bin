
THIS_ROOT = $(HOME)/proj/mcu/tronferno-mcu-bin
TRONFERNO_MCU_ROOT = ./tronferno-mcu
BUILD_BASE = tmp
TRONFERNO_MCU_REPO = $(HOME)/proj/mcu/tronferno-mcu

ESP8266_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_firmware BUILD_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_build -C $(TRONFERNO_MCU_ROOT)


AVR_FW_DIR = ../../../$(BUILD_BASE)/atmega328_firmware
AVR_BUILD_DIR = $(THIS_ROOT)/$(BUILD_BASE)/atmega328_build
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(AVR_FW_DIR) BUILD_BASE=$(AVR_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)


ESP32_BUILD_DIR = ../../../$(BUILD_BASE)/esp32_build
ESP32_MK_FLAGS = DISTRO=1 BUILD_DIR_BASE=$(ESP32_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

BUILD_DIRS = $(BUILD_BASE)/esp8266_build $(BUILD_BASE)/atmega328_build
FW_DIRS = $(BUILD_BASE)/esp8266_firmware $(BUILD_BASE)/atmega328_firmware


#ATMEGA328_CO = c25106956f0390be7b5d7ddef5f92cac19734172
#ATMEGA328_CO = e43ceccbd621e6cfc8847afe6f6436b7022a7062
#ATMEGA328_CO = ec3374a68515502bc80e721a971b2995110ec7ec
ATMEGA328_CO = e29af9767c6492f66b1fe99637737d14fd82d5b9
.PHONY : all clean clean2 commit pull push distribute fetch_source esp8266 esp32 atmega328



distribute : all commit push


esp8266:  
	cd $(TRONFERNO_MCU_ROOT) && git checkout master
	mkdir -p firmware/esp8266
	make  $(ESP8266_MK_FLAGS) esp8266-all
	cp -p $(BUILD_BASE)/esp8266_firmware/eagle.flash.bin $(BUILD_BASE)/esp8266_firmware/eagle.irom0text.bin ~/esp/ESP8266_NONOS_SDK/bin/esp_init_data_default_v08.bin ./firmware/esp8266/

esp32: 
	cd $(TRONFERNO_MCU_ROOT) && git checkout master
	mkdir -p firmware/esp32
	make   $(ESP32_MK_FLAGS) esp32-all
	cp -p  $(BUILD_BASE)/esp32_build/bootloader/bootloader.bin  $(BUILD_BASE)/esp32_build/tronferno-mcu.bin $(BUILD_BASE)/esp32_build/partitions.bin ./firmware/esp32/

atmega328:
	cd $(TRONFERNO_MCU_ROOT) && mv user/esp32/sdkconfig user/esp32/xxx_sdkconfig && git checkout $(ATMEGA328_CO)
	mkdir -p firmware/atmega328
	$(MAKE)  $(AVR_MK_FLAGS) atmega328-all
	cp -p $(BUILD_BASE)/atmega328_firmware/fernotron.hex $(BUILD_BASE)/atmega328_firmware/fernotron.eep ./firmware/atmega328/
	cd $(TRONFERNO_MCU_ROOT) && git checkout master && mv user/esp32/xxx_sdkconfig user/esp32/sdkconfig

all:  fetch_source esp8266 esp32 atmega328


clean:
	rm -r tmp

clean2:
	$(MAKE) $(ESP8266_MK_FLAGS) esp8266-clean
	$(MAKE) $(AVR_MK_FLAGS) atmega328-clean
	$(MAKE) $(ESP32_MK_FLAGS) esp32-clean

fetch_source:
	cd $(TRONFERNO_MCU_ROOT) && git checkout master && git clean -fd && git pull 

atmega328_source: fetch_source
	cd $(TRONFERNO_MCU_ROOT) && git checkout $(ATMEGA328_CO)


commit :
	git commit -a -m "new binaries"

pull :
	git pull

push :
	git push


