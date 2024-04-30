#!/bin/sh

# Usage
if [ $# -ne 1 ]; then
    echo "usage: . flash_esp32.sh /dev/ttyUSBx"
    exit 1
fi

esptool_bin="tools/esptool-linux-amd64/esptool"
esptool_py="python tools/esptool.py"
esptool="echo \nERROR: ESPTOOL NOT SET\n\n"
esptool_py_runs="TBD"
has_pip_installed="TBD"
has_pyserial_installed="TBD"
comport=$1
part_ota0=0x100000
part_ota_init=0x10000
fwdir=firmware/esp32


# check if esptool just runs out of the box
if $esptool_bin --help 2>/dev/null 1>/dev/null ; then esptool_bin_runs="yes"; else esptool_bin_runs="no"; fi
if $esptool_py --help 2>/dev/null 1>/dev/null ; then esptool_py_runs="yes"; else esptool_py_runs="no"; fi
if python -m pip --version 2>/dev/null 1>/dev/null ; then has_pip_installed="yes"; else has_pip_installed="no"; fi
if python -m serial --help 2>/dev/null 1>/dev/null ; then has_pyserial_installed="yes"; else has_pyserial_installed="no"; fi
echo
echo "############################################"
echo "bundled esptool binary works: " $esptool_bin_runs
echo "bundled esptool.py works: " $esptool_py_runs
echo "python3-pip installed: " $has_pip_installed
echo "pyserial installed: " $has_pyserial_installed
echo
if [ "$esptool_bin_runs" = "yes" -o "$esptool_py_runs" = "yes" -o "$has_pip_installed" = "yes" ]; then
	echo "Installation requirements fullfilled"
else
	echo "Installation requirements not fullfilled"
fi
echo "############################################"
echo


#flash firmware using esptool.py

run_esptool() {
echo "Flash firmware using esptool.py"
$esptool --chip esp32 --port $comport --baud 230400 \
    --before default_reset --after hard_reset \
    write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect \
    0x1000 $fwdir/bootloader.bin \
    0x8000 $fwdir/partitions.bin \
    $part_ota0 $fwdir/tronferno-mcu.bin \
    $part_ota_init $fwdir/ota_data_initial.bin
}


#try to install esptool unsing pip packet manager
#if esptool does not work (e.g. its module folder is missing on FHEM server)

install_esptool() {
echo "Try to install esptool,py using python module pip (package installer"
path="./tools/python"
# Install local python installation of esptool using python -m pip
if ! test -e $path; then
    mkdir -p $path &&
        python -m pip install -t $path esptool
fi

export PYTHONPATH=$path:$PYTHONPATH
esptool="tools/python/bin/esptool.py"
}



if [ "$esptool_bin_runs" = "yes" ]; then
        esptool=$esptool_bin;
       	run_esptool;
elif [ "$esptool_py_runs" = "yes" ]; then
        esptool=$esptool_py;
       	run_esptool;
elif [ "$has_pip_installed" = "yes" ]; then
        esptool=$esptool_py;
       	install_esptool && run_esptool
else
	echo "error: You need to install python3-pip package first";
	exit 1;
fi 

