set comport=%1

tools\esptool.exe --chip esp32 --port "%comport%" --baud 230400 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 firmware/esp32/bootloader.bin 0x100000 firmware/esp32/tronferno-mcu.bin 0x8000 firmware/esp32/partitions.bin 0x10000 firmware/esp32/ota_data_initial.bin
