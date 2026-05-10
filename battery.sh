#! /bin/bash
upower -i $(upower -e | grep 'BAT')
#:upower -e
