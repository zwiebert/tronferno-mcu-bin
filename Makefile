

TRONFERNO_MCU_ROOT = ../tronferno-mcu
THIS_ROOT = ../tronferno-mcu-bin

MK_FLAGS =  FW_BASE=$(THIS_ROOT)/.firmware BUILD_BASE=$(THIS_ROOT)/.build CPPFLAGS+=-DDISTRIBUTION -C $(TRONFERNO_MCU_ROOT)


.PHONY : all commit pull push distribute


distribute : all pull commit push


all:
	make $(MK_FLAGS) esp8266-all
	cp -p .firmware/eagle.flash.bin .firmware/eagle.irom0text.bin ./firmware/

clean:
	make $(MK_FLAGS) esp8266-clean


commit :
	git commit -a -m "new binaries"

pull :
	git pull

push :
	git push


