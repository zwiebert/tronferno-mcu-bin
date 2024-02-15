import serial
import re

from .getch import is_windows

_ser_list = sorted(
    ports.device for ports in serial.tools.list_ports.comports())
_ser_port = _ser_list[0] if len(
    _ser_list) else "com1" if is_windows else "/dev/ttyUSB0"

misc_data = {
    "ipaddr":"1.2.3.4",
}

c_mcu_a = [
    ("network", "lan-wlan"),
    ("wlan-password", ""),
    ("wlan-ssid", ""),
    ("http-enable", "1"),
    ("http-user", ""),
    ("http-password", ""),
    ("mqtt-enable", ""),
    ("mqtt-url", ""),
    ("mqtt-user", ""),
    ("mqtt-password", ""),
]

c_mcu = dict(c_mcu_a)


opts_verify = {
    "network": re.compile("^(none|ap|wlan|lan|lan-wlan)$"),
    "mqtt-url": re.compile("^mqtt://"),
    "mqtt-enable": re.compile("^[01]$"),
    "http-enable": re.compile("^[01]$"),
}

opts_help = {
    "network": "choose on of: none, ap, wlan, lan, lan-wlan",
    "mqtt-url": "MQTT server/broker URL. example: mqtt-url = mqtt://192.168.1.42:7777",
    "mqtt-enable": "set it to 0 or 1 for disable or enable MQTT client",
    "http-enable": "set it to 0 or 1 for disable or enable HTTP server",
}

c_flash_a = [
    ("serial-port", _ser_port),
    ("serial-baud", "115200"),
    ("flash-size", "detect"),
    ("chip", "esp32"),
]

c_flash = dict(c_flash_a)

flash_files = {
    "esp32":   ["0x001000", "firmware/esp32/bootloader.bin",
                "0x008000", "firmware/esp32/partitions.bin",
                "0x100000", "firmware/esp32/tronferno-mcu.bin",
                "0x010000", "firmware/esp32/ota_data_initial.bin"],
    "esp8266": ["0x000000", "firmware/esp8266/eagle.flash.bin",
                "0x010000", "firmware/esp8266/eagle.irom0text.bin",
                "0x3FC000", "firmware/esp8266/esp_init_data_default_v08.bin",
                "0x3FE000", "firmware/esp8266/blank.bin"],
}


