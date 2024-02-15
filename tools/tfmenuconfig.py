#!/usr/bin/env python
################################################################################
# tfmenuconfig.py  - menu app to
# 1) program firmware interactively
# 2) configure WLAN and MQTT login data via serial port
##
# Author: Bert Winkelmann <tf.zwiebert@online.de> (2019)
# License: GNU General Public License Version 3 (GNU GPL v3)
################################################################################

from tfmenuconfig import menu, appcfg;


def main():
    appcfg.do_app_config_read(menu.CONFIG_FILE)
    while (menu.ui_menu_root()):
        pass


if __name__ == '__main__':
    main()
