#!/bin/sh

esptool="tools/esptool.py"
esptool_runs="TBD"
has_pip_installed="TBD"
has_pyserial_installed="TBD"
prog=tools/tfmenuconfig.py


# check if esptool just runs out of the box
if python $esptool --help 2>/dev/null 1>/dev/null ; then esptool_runs="yes"; else esptool_runs="no"; fi
if python -m pip --version 2>/dev/null 1>/dev/null ; then has_pip_installed="yes"; else has_pip_installed="no"; fi
if python -m serial --help 2>/dev/null 1>/dev/null ; then has_pyserial_installed="yes"; else has_pyserial_installed="no"; fi
echo
echo "############################################"
echo "bundled esptool.py works: " $esptool_runs
echo "python3-pip installed: " $has_pip_installed
echo "pyserial installed: " $has_pyserial_installed
echo
if [ "$esptool_runs" = "yes" -o "$has_pip_installed" = "yes" ]; then
	echo "Installation requirements fullfilled"
else
	echo "Installation requirements not fullfilled"
fi
echo "############################################"
echo


#flash firmware using esptool.py

run_menutool() {
	clear
	python $prog
}

install_pyserial() {
	python -m pip install pyserial
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


if [ "$esptool_runs" = "yes" ]; then
       	run_menutool;
elif [ "$has_pip_installed" = "yes" ]; then
       	#install_esptool && run_menutool
       	install_pyserial && run_menutool
else
	echo "error: You need to install python3-pip package first";
	exit 1;
fi 

