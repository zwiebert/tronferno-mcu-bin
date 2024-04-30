import re

from serial.tools import list_ports, miniterm

from .appcfg import do_app_config_save
from .mcucom import do_tfmcu_get_ip_address, do_tfmcu_write_config_all, ui_verify_opt, ui_verify_mcu_opts
from .ui import clear_screen, getch, press_enter, ask_yes_no
from .espt import do_esptool_chip_id, do_esptool_erase_flash, do_esptool_write_flash
from .globvar import c_flash, c_flash_a, c_mcu, c_mcu_a, opts_help, misc_data
from .loc import loc, loc_cycle_language

CONFIG_FILE = "config.ini"

def print_header(header, menu=""):
    menu_hdr = '----------------------------------------'[0:len(menu)]
    clear_screen()
    txt = ""
    if header:
        txt += header + '\n'
    if menu:
        txt += menu_hdr + '\n' + menu + '\n' + menu_hdr
    print(txt + '\n')


def ui_process_flash_opts(key, value):
    """
    handle special options
    """
    if key == "serial-port":
        return ui_menu_serial()
    return ""


def ui_menu_serial():
    """
    choose serial port from menu or allow user to provide a device name
    """
    ser_port = c_flash["serial-port"]
    ui_menu_unknown_key_pressed(ser_port)
    ser_list = sorted(ports.device for ports in list_ports.comports())
    msg_text = ""
    n = 0
    for port in ser_list:
        n += 1
        msg_text += " [%d] %s\n" % (n, port)
    msg_text += " [e] {edit}\n".format(edit=loc["sm_e"])
    while True:
        print_header(loc["sm_hdr"], "[y] {apply} | [X] {exit}".format(
            apply=loc["xm_y"], exit=loc["xm_X"]))
        print(msg_text)
        ui_menu_print_last_error_msg()
        c = getch()
        try:
            if c == 'e':
                ser_port = input("serial port: ")
                ui_menu_unknown_key_pressed(ser_port)
            elif c == 'X':
                return c_flash["serial-port"]
            elif c == 'y':
                return ser_port
            elif re.match("[1-9]", c) and int(c) <= n:
                ser_port = ser_list[int(c) - 1]
                ui_menu_unknown_key_pressed(ser_port)
            else:
                ui_menu_unknown_key_pressed()
        except Exception as e:
            print("ex: %s" % e)
            press_enter()


# FIXME: start with numbers 1..9 then letters a...w
def menu_char_to_idx(c): return ord(c) - ord("a")


def menu_idx_to_char(i): return chr(i + ord("a"))


error_msg = ""


def ui_menu_unknown_key_pressed(msg=loc["err_keyInvalid"]):
    global error_msg
    error_msg = msg


def ui_menu_print_last_error_msg():
    global error_msg
    print(error_msg+"\n")
    error_msg = ""


def ui_menu_opts(header, c_arr, c_hash, proc_opts=0, ver_opts=0):
    """
    creates a user menu from the given function arguments
    """
    c_items = []
    for key, value in c_arr:
        c_items.append(tuple([key, c_hash[key]]))

    changed = {}
    while True:
        msg_text = ""
        n = 0
        for key, value in c_items:
            msg_text += " [%s] %s (%s)\n" % (menu_idx_to_char(n), key, value)
            n += 1
        print_header(header, "[y] {apply} | [X] {exit}".format(
            apply=loc["xm_y"], exit=loc["xm_X"]))
        print(msg_text)
        ui_menu_print_last_error_msg()
        c = getch()
        if c == "X":
            return
        elif c == "y":
            for key in changed:
                c_hash[key] = changed[key]
            return
        else:
            try:
                idx = menu_char_to_idx(c)
                key, value = c_items[idx]
                s = ""
                if key in opts_help:
                    print("help: " + opts_help[key])
                if proc_opts:
                    s = proc_opts(key, value)
                if not s:
                    s = input("Enter value for %s (%s): ..." % (key, value))
                if s and ui_verify_opt(key, s) and (not ver_opts or ver_opts(key, s)):
                    c_items[idx] = (key, s)
                    changed[key] = s
            except Exception as e:
                print("ex: %s" % e)
                ui_menu_unknown_key_pressed()


def ui_menu_root():
    """
    user main menu. should be called from an endless loop as long it returns True
    """
    print_header(loc["rm_hdr"], "[s] {save}  [X] {exit} [L] {lang}".format(
        save=loc["rm_s"], exit=loc["rm_X"], lang=loc["rm_L"]))
    print("\n1) %s:\n" % (loc["rm_p1"]) +
          "    [i] {txt}\n".format(txt=loc["rm_i"]) +
          "    [I] {txt} ({chip}@{port}):\n".format(txt=loc["rm_I"], chip=c_flash["chip"], port=c_flash["serial-port"]) +
          "    [f] {txt}\n".format(txt=loc["rm_f"]) +
          "    [t] {txt}\n".format(txt=loc["rm_t"]) +
          "\n2) {txt} ({chip}@{port}):\n".format(txt=loc["rm_p2"], chip=c_flash["chip"], port=c_flash["serial-port"]) +
          "    [E] {txt}\n".format(txt=loc["rm_E"]) +

          "    [w] {txt}\n".format(txt=loc["rm_w"]) +
          "\n3) {txt}\n".format(txt=loc["rm_p3"]) +
          "    [c] {txt}\n".format(txt=loc["rm_c"]) +
          "    [o] {txt}\n".format(txt=loc["rm_o"]) +
          "\n4) {txt}: IP-Address: {ipa}, Hostname: tronferno\n".format(txt=loc["rm_p4"], ipa=misc_data["ipaddr"]) +
          "    [a] {txt}\n".format(txt=loc["rm_a"]) +
          "   URLs: http://{ipa} -or- http://tronferno.fritz.box\n".format(ipa=misc_data["ipaddr"]) +
          "\n")
    ui_menu_print_last_error_msg()
    c = getch()

    if c == "c":
        ui_menu_opts(loc["cm_hdr"], c_mcu_a, c_mcu, ver_opts=ui_verify_mcu_opts)
    elif c == "o":
        do_tfmcu_write_config_all()
        press_enter()
    elif c == "a":
        ipaddr = do_tfmcu_get_ip_address()
        if ipaddr:
            if ask_yes_no(loc["rm_a_req"].format(ipa=ipaddr)):
                misc_data["ipaddr"] = ipaddr
    elif c == "X":
        if ask_yes_no(loc["rm_X_req"]):
            do_app_config_save(CONFIG_FILE)
            print(loc["rm_s_done"].format(file=CONFIG_FILE))
        return False
    elif c == "E":
        if ask_yes_no(loc["rm_E_req"]):
            do_esptool_erase_flash()
            press_enter()
    elif c == "w":
        do_esptool_write_flash()
        press_enter()
    elif c == "i":
        clear_screen()
        port = do_esptool_chip_id()
        if port != None:
            c_flash["serial-port"] = port
    elif c == "I":
        clear_screen()
        do_esptool_chip_id(c_flash["serial-port"])
    elif c == "s":
        do_app_config_save(CONFIG_FILE)
        ui_menu_unknown_key_pressed(loc["rm_s_done"].format(file=CONFIG_FILE))
    elif c == "f":
        ui_menu_opts(loc["fm_hdr"], c_flash_a, c_flash,
                     proc_opts=ui_process_flash_opts)
    elif c == "t":
        clear_screen()
        if ask_yes_no(loc["rm_t_req"]):
            try:
                miniterm.main(c_flash["serial-port"], 115250)
            except Exception as e:
                print("ex: %s" % e)
                press_enter()
    elif c == "L":
        loc_cycle_language()
    else:
        ui_menu_unknown_key_pressed()
    return True
