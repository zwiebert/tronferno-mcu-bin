import serial
import esptool

from serial.tools import list_ports
from .globvar import c_flash, flash_files
from .ui import press_enter, ask_yes_no


def do_esptool_write_flash():
    args = ["--chip", c_flash["chip"],
            "--port", c_flash["serial-port"],
            "--baud", c_flash["serial-baud"],
            "write_flash",
            "-z",
            "--flash_mode", "dio",
            "--flash_freq", "40m",
            "--flash_size", c_flash["flash-size"]]
    args.extend(flash_files[c_flash["chip"]])
    try:
        esptool.main(args)
    except esptool.FatalError as e:
        print('\nA fatal error occurred: %s' % e)
    except serial.serialutil.SerialException as e:
        print('\nerror: %s' % e)


def do_esptool_erase_flash():
    args = ["--chip", c_flash["chip"],
            "--port", c_flash["serial-port"],
            "--baud", c_flash["serial-baud"],
            "erase_flash"]
    try:
        esptool.main(args)
    except esptool.FatalError as e:
        print('\nA fatal error occurred: %s' % e)
    except serial.serialutil.SerialException as e:
        print('\nerror: %s' % e)


def do_esptool_chip_id(port=""):
    args = ["--port", port, "chip_id"] if port else ["chip_id"]
    return_port = False if port else True
    ser_list = [port] if port else reversed(
        sorted(ports.device for ports in list_ports.comports()))
    try:
        if not ser_list:
            esptool.main(args)
        else:
            for port in ser_list:
                try:
                    esptool.main(["--port", port] + args)
                    if (not return_port):
                        press_enter()
                        return port
                    if ask_yes_no(f"Chip found at {port}! Use this port?"):
                        return port
                except Exception as e:
                    print(f"unsuccessful: {e}")

    except esptool.FatalError as e:
        print('\nerror: %s' % e)
    except serial.serialutil.SerialException as e:
        print('\nerror: %s' % e)
    print("no chip found on serial port")
    press_enter()
    return None
