#!/bin/sh

clear
prog=tools/tfmenuconfig.py

python -m pip install -q pyserial && \
python $prog || python3 $prog || python2 $prog
