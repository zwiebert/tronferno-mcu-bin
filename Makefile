THIS_ROOT := $(realpath .)
TRONFERNO_MCU_ROOT = $(THIS_ROOT)/tronferno-mcu
BUILD_BASE = $(THIS_ROOT)/tmp
TRONFERNO_MCU_REPO := $(realpath ../tronferno-mcu)
COMPONENTS_MCU_REPO := $(realpath ../components-mcu)
TRONFERNO_LIB_REPO := $(realpath ../tronferno-lib)

ESP8266_MK_FLAGS = DISTRO=1 FW_BASE=$(BUILD_BASE)/esp8266_firmware BUILD_BASE=$(BUILD_BASE)/esp8266_build -C $(TRONFERNO_MCU_ROOT)


AVR_FW_DIR = $(BUILD_BASE)/atmega328_firmware
AVR_BUILD_DIR = $(BUILD_BASE)/atmega328_build
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(AVR_FW_DIR) BUILD_BASE=$(AVR_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)


ESP32_BUILD_DIR = $(BUILD_BASE)/esp32_build
ESP32_MK_FLAGS = DISTRO=1 BUILD_BASE=$(ESP32_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

ESP32_TEST_BUILD_DIR = $(BUILD_BASE)/esp32_test_build
ESP32_TEST_MK_FLAGS = DISTRO=1 BUILD_BASE=$(ESP32_TEST_BUILD_DIR) -C $(TRONFERNO_MCU_ROOT)

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


distribute : clean all commit push tag
build : clean all 
deploy: commit push tag

.PHONY : print_branch
print_branch:
	@echo ${GIT_BRANCH}

esp8266: pre_esp8266 main_esp8266 post_esp8266
esp32: pre_esp32 main_esp32 post_esp32
esp32_test: pre_esp32 test_esp32
atmega328: pre_atmega328 main_atmega328 post_atmega328

co_master:
	-rm -rf $(TRONFERNO_MCU_ROOT)
	git clone --local --no-hardlinks $(TRONFERNO_MCU_REPO) --branch $(GIT_BRANCH) --single-branch
	$(eval APP_VERSION := $(shell sed -E -e '/APP_VERSION/!d' -e 's/^.*APP_VERSION *"(.+)"/\1/' $(TRONFERNO_MCU_ROOT)/src/components/app_config/include/app_config/proj_app_cfg.h))
	git -C $(TRONFERNO_MCU_ROOT) submodule init external/components-mcu external/tronferno-lib
	echo "locally fetch submodule components-mcu" ${GIT_BRANCH}
	cd $(TRONFERNO_MCU_ROOT)/external/components-mcu &&  git -C $(TRONFERNO_MCU_ROOT) submodule update --no-fetch || true && git checkout -B $(GIT_BRANCH) && git pull $(COMPONENTS_MCU_REPO) $(GIT_BRANCH)
	echo "locally fetch submodule tronferno-lib" ${GIT_BRANCH}
	cd $(TRONFERNO_MCU_ROOT)/external/tronferno-lib &&  git -C $(TRONFERNO_MCU_ROOT) submodule update --no-fetch || true && git checkout -B $(GIT_BRANCH) && git pull $(TRONFERNO_LIB_REPO) $(GIT_BRANCH)
	git submodule init  &&  git -C $(TRONFERNO_MCU_ROOT) submodule update --init --recursive

pre_esp8266: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(GIT_BRANCH) && git pull && git clean -fd
	mkdir -p firmware/esp8266
	make  $(ESP8266_MK_FLAGS) esp8266-clean
main_esp8266:
	make  $(ESP8266_MK_FLAGS) esp8266-all
post_esp8266: copy_docs
	cp -p $(BUILD_BASE)/esp8266_firmware/eagle.flash.bin $(BUILD_BASE)/esp8266_firmware/eagle.irom0text.bin ~/esp/ESP8266_NONOS_SDK/bin/esp_init_data_default_v08.bin ./firmware/esp8266/


pre_esp32: co_master test_host
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(GIT_BRANCH) && git pull && git clean -fd
	mkdir -p firmware/esp32
	make  $(ESP32_MK_FLAGS) esp32-clean
test_esp32:
	make $(ESP32_TEST_MK_FLAGS) esp32-test-clean esp32-test-build esp32-test-flash esp32-test-run
test_host:
	make $(ESP32_TEST_MK_FLAGS) host-test-all
main_esp32:
	make -j  $(ESP32_MK_FLAGS) esp32-all
post_esp32: copy_docs
	cp -p $(ESP32_BUILD_DIR)/bootloader/bootloader.bin $(ESP32_BUILD_DIR)/tronferno-mcu.elf $ $(ESP32_BUILD_DIR)/tronferno-mcu.bin $(ESP32_BUILD_DIR)/ota_data_initial.bin ./firmware/esp32/
	cp -p $(ESP32_BUILD_DIR)/partition_table/partition-table.bin ./firmware/esp32/partitions.bin

pre_atmega328: co_master
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(ATMEGA328_CO) &&  git clean -fd
	mkdir -p firmware/atmega328
	make  $(AVR_MK_FLAGS) atmega328-clean
main_atmega328:
	make  $(AVR_MK_FLAGS) atmega328-all
post_atmega328: copy_avr_docs
	cp -p $(BUILD_BASE)/atmega328_firmware/fernotron.hex $(BUILD_BASE)/atmega328_firmware/fernotron.eep ./firmware/atmega328/

all:  esp32


clean:
	-rm -r tmp
	-rm -r tronferno-mcu/unity

clean2:
	make $(ESP8266_MK_FLAGS) esp8266-clean
	make $(AVR_MK_FLAGS) atmega328-clean
	make $(ESP32_MK_FLAGS) esp32-clean

commit :
	git commit -a -m "Version $(APP_VERSION) ($(GIT_BRANCH))"

pull :
	git pull

push :
	git push

tag:
	git -C $(TRONFERNO_MCU_ROOT) describe --tags | xargs git tag --force
	git describe --tags | xargs git push origin
	git describe --tags | xargs git push hs

# copy user docs from source repository
.PHONY : copy_docs copy_avr_docs
copy_docs:
	cp -p $(TRONFERNO_MCU_ROOT)/README.md ./README_src.md
	mkdir -p docs/img docs/img/gwcc
	cp -p $(TRONFERNO_MCU_ROOT)/docs/*.md docs/ && git add docs/*.md
	cp -p $(TRONFERNO_MCU_ROOT)/docs/*.pdf docs/ && git add docs/*.pdf
	cp -p $(TRONFERNO_MCU_ROOT)/docs/img/*.png docs/img/ && git add docs/img/*.png
	cp -p $(TRONFERNO_MCU_ROOT)/docs/img/gwcc/*.jpg docs/img/gwcc && git add docs/img/gwcc/*.jpg
copy_avr_docs:
	cd $(TRONFERNO_MCU_ROOT) && git checkout --force $(ATMEGA328_DOC_CO) &&  git clean -fd
	mkdir -p docs
	cp -p $(TRONFERNO_MCU_ROOT)/docs/mcu_atmega328.md docs/ && git add docs/mcu_atmega328.md


# the following targets needs to be made on Windows system (git-bash is fine)
.PHONY : windows
windows: tools/dist/esptool/esptool.exe  tools/dist/tfmenuconfig/tfmenuconfig.exe
windows_clean:
	rm -rf tools/dist tools/build

tools/dist/esptool/esptool.exe: tools/esptool.py
	cd tools && pyinstaller -y esptool.py
	cd tools && mkdir -p dist/esptool/_internal/esptool/targets &&\
		cp -r esptool/targets/stub_flasher dist/esptool/_internal/esptool/targets

tools/dist/tfmenuconfig/tfmenuconfig.exe: tools/tfmenuconfig.py tools/tfmenuconfig/appcfg.py tools/tfmenuconfig/espt.py tools/tfmenuconfig/getch.py tools/tfmenuconfig/globvar.py tools/tfmenuconfig/__init__.py tools/tfmenuconfig/mcucom.py tools/tfmenuconfig/menu.py tools/tfmenuconfig/ui.py tools/tfmenuconfig/loc.py
	cd tools && pyinstaller -y tfmenuconfig.py
	cd tools && mkdir -p dist/tfmenuconfig/_internal/esptool/targets &&\
		cp -r esptool/targets/stub_flasher dist/tfmenuconfig/_internal/esptool/targets

