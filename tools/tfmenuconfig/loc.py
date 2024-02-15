# -*- coding: utf-8 -*-
    

_all = {

    "en" : {
        "err_keyInvalid": "Key not in menu! Try again",
            
        "rm_hdr":    "Tronferno MCU Flash Assistant",
        "rm_s":      "Save",
        "rm_s_done": "Options saved in {file}",
        "rm_X":      "Exit",
        "rm_X_req":  "Do you want to save?",
        "rm_L":      "Language",


        "rm_p1":     "Connect to the Microcontroller",
        "rm_i":      "Search ports for chip",
        "rm_I":      "Print info about chip",
        "rm_f":      "Configure serial port and more",
        "rm_t":      "Open MiniTerm serial terminal",
        "rm_t_req":  "This opens a serial terminal for the MCU commnd line interface.\n"
                    "There you can type Ctrl-T Ctrl-E  to enable local echo\n"
                    "                   Ctrl-T Q       to quit\n"
                    "After flashing tronferno firmware you can also type:\n"
                    "                   help;          to discover CLI commands\n"
                    "Do you want to continue?",
        "rm_p2":     "Flash the Microcontroller",
        "rm_E":      "Erase flash. This wipes all data/firmware on the device",
        "rm_E_req":  "This erases all data on the chip! Are you sure?",
        "rm_w":      "Write firmware to flash",
        "rm_p3":     "Connect the Microcontroller to Network",
        "rm_c":      "Configure tronferno-mcu options like WLAN and MQTT login data",
        "rm_o":      "Write tronferno-mcu options to chip via serial port (do this *after* flashing the firwmware)",
        "rm_p4":     "Access the builtin webserver",
        "rm_a":      "Get IP address from chip",
        "rm_a_req":  "Got IP-address {ipa} from device! Use this address?",
            
        
        "sm_hdr":    "Choose Serial Port",
        "sm_e":      "Edit",
        
        "cm_hdr":    "MCU Network Connectivity Setup",
        "fm_hdr":    "Serial/Flash Setup",
        
        "xm_y":      "Apply",
        "xm_X":      "Discard",
        
},

    "de" : {
        "rm_hdr":    "Tronferno MCU Flash Assistent",
        "rm_s":      "Speichern",
        "rm_L":       "Sprache",
        "rm_s_done": "Optionen gespeichert in Datei {file}",
        "rm_X":      "Beenden",
        "rm_X_req":  "Vor dem Beenden speichern?",
        "rm_p1":     "Verbindung zum Mikrocontroller",
        "rm_i":      "Suche Chip an USB ports",
        "rm_I":      "Zeige Info über Chip",
        "rm_f":      "Konfiguriere USB und Flash",
        "rm_t":      "Starte serielles Terminal (Miniterm)",
        "rm_t_req":  "Öffne ein serielles Terminal für das MCU Kommandozeilen-Interface (CLI).\n"
                     "Dortige Eingaben   Ctrl-T Ctrl-E  um die eigenen Einngaben zu sehen\n"
                     "                   Ctrl-T Q       zum Beenden\n"
                     "Nach dem flashen der Firmware dann:\n"
                     "                   help;          zum Anzeigen der CLI Kommandos\n"
                     "Terminal jetzt öffnen?",
        "rm_p2":     "Flashe dem Mikrocontroller",
        "rm_E":      "Lösche Flash Speicher komplett",
        "rm_E_req":  "Dies löscht *alle* Daten und Firmware. Bist du sicher?",
        "rm_w":      "Flashe die Firmware",
        "rm_p3":     "Verbinde den Mikrocontroller zum Netzwerk",
        "rm_c":      "Konfigure Verbindungsdaten (WLAN,MQTT)",
        "rm_o":      "Schreibe Verbindungsdaten zum Mikrocontroller (erst nach dem Flashen möglich)",
        "rm_p4":     "Zugriff auf Webserver erlangen",
        "rm_a":      "Hohle IP Adresse vom Chip",
         "rm_a_req": "Geräte-IP-Adresse ist {ipa}. Adresse übernehmen?",
       
        "sm_hdr":    "Seriellen Anschluss auswählen",
        "sm_e":      "Texteingabe",
        
        "xm_y":      "Übernehmen",
        "xm_X":      "Verwerfen",
    }
}

lang = "en"
loc = dict()

def loc_set_language(language="en"):
    global lang, loc
    lang = language
    for key in _all["en"]:
        try:
            loc[key] = _all[lang][key]
        except:
            loc[key] = _all["en"][key]

    
def loc_cycle_language():
    loc_set_language("en" if lang == "de" else "de")


try:
    import locale
    lo = locale.getlocale()
    lang = lo[0][0:2]
except Exception as e:
    pass

loc_set_language(lang)

