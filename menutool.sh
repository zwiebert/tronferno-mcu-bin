#!/bin/sh

clear
prog=tools/tfmenuconfig.py

python $prog || python3 $prog || python2 $prog
