import sys

from .globvar import c_mcu, c_flash

import configparser

cfg = configparser.ConfigParser()


def do_app_config_save(path):
    """
    saves user configured data to file PATH
    """
    cf = open(path, "w")
    if not cfg.has_section('MCU'):
        cfg.add_section('MCU')
    for key, value in c_mcu.items():
        cfg.set('MCU', key, value)
    if not cfg.has_section('FLASH'):
        cfg.add_section('FLASH')
    for key, value in c_flash.items():
        cfg.set('FLASH', key, value)
    cfg.write(cf)
    cf.close()


def do_app_config_read(path):
    """
    reads user configured data to file PATH
    """
    try:
        cf = open(path, "r")
        cfg.read_file(cf)
        for key in cfg.options('MCU'):
            value = cfg.get('MCU', key)
            c_mcu[key] = value
            cf.close()
        for key in cfg.options('FLASH'):
            value = cfg.get('FLASH', key)
            c_flash[key] = value
            cf.close()
    except:
        return False
    return True
