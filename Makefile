
THIS_ROOT = $(HOME)/proj/mcu/tronferno-mcu-bin
TRONFERNO_MCU_ROOT = ./tronferno-mcu
BUILD_BASE = tmp
TRONFERNO_MCU_REPO = $(HOME)/proj/mcu/tronferno-mcu

ESP8266_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_firmware BUILD_BASE=$(THIS_ROOT)/$(BUILD_BASE)/esp8266_build -C $(TRONFERNO_MCU_ROOT)


AVR_FW_DIR = ../../../$(BUILD_BASE)/atmega328_firmware
AVR_BUILD_DIR = $(THIS_ROOT)/$(BUILD_BASE)/atmega328_build
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(AVR_FW_DIR) BUILD_BASE=$(AVR_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)


ESP32_BUILD_DIR = $(THIS_ROOT)/$(BUILD_BASE)/esp32_build
ESP32_MK_FLAGS = DISTRO=1 BUILD_DIR_BASE=$(ESP32_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

ESP32_TEST_BUILD_DIR = $(THIS_ROOT)/$(BUILD_BASE)/esp32_test_build
ESP32_TEST_MK_FLAGS = TEST_BUILD_DIR_BASE=$(ESP32_TEST_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

BUILD_DIRS = $(BUILD_BASE)/esp8266_build $(BUILD_BASE)/atmega328_build
FW_DIRS = $(BUILD_BASE)/esp8266_firmware $(BUILD_BASE)/atmega328_firmware

ATMEGA328_CO = e29af9767c6492f66b1fe99637737d14fd82d5b9
ATMEGA328_DOC_CO = 7904350e42f668603a721bc844ca3f4614186431
.PHONY : all clean clean2 commit pull push distribute fetch_source
.PHONY : esp32 pre_esp32 main_esp32 post_esp32
.PHONY : esp8266 pre_esp8266 main_esp8266 post_esp8266
.PHONY : atmega328 pre_atmega328 main_atmega328 post_atmega328
.PHONY : co_master

GIT_BRANCH ?= $(shell git branch | grep \* | cut -d ' ' -f2)


distribute : clean all commit push

.PHONY : print_branch
print_branch:
	@echo ${GIT_BRANCH}

esp8266: pre_esp8266 main_esp8266 post_esp8266
esp32: pre_esp32 test_esp32 main_esp32 post_esp32
esp32_test: pre_esp32 test_esp32
esp32lan: pre_esp32 main_esp32lan post_esp32lan
atmega328: pre_atmega328 main_atmega328 post_atmega328

co_master:
	-rm -rf $(THIS_ROOT)/$(TRONFERNO_MCU_ROOT)
	git clone --local --no-hardlinks $(TRONFERNO_MCU_REPO) --branch $(GIT_BRANCH) --single-branch
	$(eval APP_VERSION := $(shell sed -E -e '/APP_VERSION/!d' -e 's/^.*APP_VERSION *"(.+)"/\1/' $(TRONFERNO_MCU_ROOT)/src/components/app/include/app/proj_app_cfg.h))


pre_esp8266: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(GIT_BRANCH) && git pull && git clean -fd
	mkdir -p firmware/esp8266
	make  $(ESP8266_MK_FLAGS) esp8266-clean
main_esp8266:
	make  $(ESP8266_MK_FLAGS) esp8266-all
post_esp8266: copy_docs
	cp -p $(BUILD_BASE)/esp8266_firmware/eagle.flash.bin $(BUILD_BASE)/esp8266_firmware/eagle.irom0text.bin ~/esp/ESP8266_NONOS_SDK/bin/esp_init_data_default_v08.bin ./firmware/esp8266/


pre_esp32: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(GIT_BRANCH) && git pull && git clean -fd
	mkdir -p firmware/esp32
	make  $(ESP32_MK_FLAGS) esp32-clean
test_esp32:
	make $(ESP32_TEST_MK_FLAGS) esp32-test-clean esp32-test-build esp32-test-flash esp32-test-run
main_esp32:
	make -j  $(ESP32_MK_FLAGS) esp32-all
post_esp32: copy_docs
	cp -p $(ESP32_BUILD_DIR)/bootloader/bootloader.bin  $(ESP32_BUILD_DIR)/tronferno-mcu.bin $(ESP32_BUILD_DIR)/ota_data_initial.bin ./firmware/esp32/
	cp -p $(ESP32_BUILD_DIR)/partition_table/partition-table.bin ./firmware/esp32/partitions.bin
main_esp32lan:
	make -j  $(ESP32_MK_FLAGS) FLAVOR_LAN=1 esp32-all
post_esp32lan:
	cp -p  $(ESP32_BUILD_DIR)/tronferno-mcu.bin  ./firmware/esp32/tronferno-mcu-lan.bin

pre_atmega328: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(ATMEGA328_CO) &&  git clean -fd
	mkdir -p firmware/atmega328
	$(MAKE)  $(AVR_MK_FLAGS) atmega328-clean
main_atmega328:
	$(MAKE)  $(AVR_MK_FLAGS) atmega328-all
post_atmega328: copy_avr_docs
	cp -p $(BUILD_BASE)/atmega328_firmware/fernotron.hex $(BUILD_BASE)/atmega328_firmware/fernotron.eep ./firmware/atmega328/

.PHONY: atmega328_doc
atmega328_doc: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(ATMEGA328_DOC_CO) &&  git clean -fd

all:  esp8266 esp32 esp32lan atmega328


clean:
	-rm -r tmp
	-rm -r tronferno-mcu/unity

clean2:
	$(MAKE) $(ESP8266_MK_FLAGS) esp8266-clean
	$(MAKE) $(AVR_MK_FLAGS) atmega328-clean
	$(MAKE) $(ESP32_MK_FLAGS) esp32-clean

commit :
	git commit -a -m "Version $(APP_VERSION) ($(GIT_BRANCH))"

pull :
	git pull

push :
	git push


# copy user docs from source repository
docs = $(shell cd  $(TRONFERNO_MCU_ROOT) && ls docs/*.md)
imgs = $(shell cd  $(TRONFERNO_MCU_ROOT) && test -d docs/img && ls docs/img/*.png)
.PHONY : copy_docs copy_avr_docs
docs/%.md : $(TRONFERNO_MCU_ROOT)/docs/%.md
	cp -p $< $@
	git add $@
docs/img/%.png : $(TRONFERNO_MCU_ROOT)/docs/img/%.png
	cp -p $< $@
copy_docs : $(docs) $(imgs)
	cp -p $(TRONFERNO_MCU_ROOT)/README.md ./README_src.md
copy_avr_docs : atmega328_doc docs/mcu_atmega328.md
print_docs:
	@echo $(docs) $(imgs)


# the following targets needs to be made on Windows system (git-bash is fine)
.PHONY : windows
windows: tools/esptool.exe  tools/dist/tfmenuconfig/tfmenuconfig.exe

tools/esptool.exe: tools/esptool.py
	cd tools && cmd '/C py2exe_esptool.cmd'

tools/dist/tfmenuconfig/tfmenuconfig.exe: tools/tfmenuconfig.py
	cd tools && winpty /c/Python27/Scripts/pyinstaller.exe -y tfmenuconfig.py
