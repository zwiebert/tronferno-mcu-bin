import sys
import json
import serial

from .globvar import c_flash, c_mcu, opts_verify, opts_help
from .ui import press_enter

MCU_CFG_RETRY_N = 6
CMD_FMT = 'config %s="%s";\n'

def do_tfmcu_read_ip_address(ser):
    """
    writes a tfmcu config key/value pair.
    """
    cmd = json.dumps({"mcu": {"ipaddr": "?"}})+";"
    ser.write(cmd.encode('utf-8'))
    lines = ser.readlines()
    for line in lines:
        line = line.decode('utf-8')
        if line.startswith("{"):
            try:
                result = json.loads(line)
                return result["mcu"]["ipaddr"]
            except Exception as e:
                print("unsuccessful: %s" % e)
                press_enter()
    return None


def do_tfmcu_write_config_2(ser, key, value):
    """
    writes a tfmcu config key/value pair.
    """
    cmd = CMD_FMT % (key, value)
    # print(cmd)
    ser.write(cmd.encode('utf-8'))
    cmd = CMD_FMT % (key, "?")
    ser.write(cmd.encode('utf-8'))
    lines = ser.readlines()
    for line in lines:
        line = line.decode('utf-8')
        if line.startswith("tf: "):
            # print(line)
            if (line.find(" "+key+"=") != -1 and line.find("="+value.strip('\"')+";") != -1):
                return True
    return False


def write_point():
    sys.stdout.write('.')
    sys.stdout.flush()


def do_tfmcu_write_config(ser, key, value):
    """
    writes a tfmcu config key/value pair and reports success or failure
    """
    sys.stdout.write("Try to set option \""+key+"\" ")
    for i in range(MCU_CFG_RETRY_N):
        write_point()
        if do_tfmcu_write_config_2(ser, key, value):
            print(" succeeded")
            return True
    print(" FAILED")
    return False


def do_tfmcu_write_config_all():
    """
    writes all tfmcu configuration and reports (except for passwords) success or failure
    """
    try:
        ser = serial.Serial(c_flash["serial-port"],
                            int(c_flash["serial-baud"]), timeout=1)
    except:
        print("cannot open serial port " + c_flash["serial-port"])
        ser_list = sorted(ports.device for ports in serial.tools.list_ports.comports())
        print(ser_list)
        return

    for key, value in c_mcu.items():
        if key.find("-password") != -1:
            do_tfmcu_write_config_2(ser, key, value)
        else:
            do_tfmcu_write_config(ser, key, value)
    do_tfmcu_write_config(ser, "restart", "1")
    ser.close()


def do_tfmcu_get_ip_address():
    """
    request the ipaddr from tfmcu
    """
    try:
        ser = serial.Serial(c_flash["serial-port"],
                            int(c_flash["serial-baud"]), timeout=1)
    except:
        print("cannot open serial port " + c_flash["serial-port"])
        ser_list = sorted(ports.device for ports in serial.tools.list_ports.comports())
        print(ser_list)
        return

    ipaddr = do_tfmcu_read_ip_address(ser)
    ser.close()
    return ipaddr


def ui_verify_mcu_opts(key, value):
    """
    check some special options for correctness
    """
    return True


def ui_verify_opt(key, value):
    """
    check general options for correctness
    """
    if key in opts_verify:
        if not opts_verify[key].match(value):
            print(
                f"ERROR: invalid formatted value for key {key:%s}: {value:%s}")
            if key in opts_help:
                print("HELP: " + opts_help[key])
            press_enter()
            return False
    return True
