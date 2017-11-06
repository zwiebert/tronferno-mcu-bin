

TRONFERNO_MCU_ROOT = ../tronferno-mcu
THIS_ROOT = ../tronferno-mcu-bin

ESP_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/.firmware BUILD_BASE=$(THIS_ROOT)/.espbuild -C $(TRONFERNO_MCU_ROOT)
AVR_MK_FLAGS = DISTRO=1 FW_BASE=$(THIS_ROOT)/.firmware BUILD_BASE=$(THIS_ROOT)/.avrbuild -C $(TRONFERNO_MCU_ROOT)


.PHONY : all clean commit pull push distribute


distribute : all pull commit push


all:
	make $(ESP_MK_FLAGS) esp8266-rebuild
	cp -p .firmware/eagle.flash.bin .firmware/eagle.irom0text.bin ./firmware/
	make $(AVR_MK_FLAGS) atmega328-rebuild
	cp -p .avrbuild/lean/fernotron.hex .avrbuild/lean/fernotron.eep ./firmware

clean:
	make $(ESP_MK_FLAGS) esp8266-clean
	make $(AVR_MK_FLAGS) atmega328-clean


commit :
	git commit -a -m "new binaries"

pull :
	git pull

push :
	git push


