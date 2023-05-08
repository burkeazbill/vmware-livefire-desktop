#!/bin/sh
# Source: https://unix.stackexchange.com/questions/27484/set-default-global-gnome-preferences-gnome-3#:~:text=Run%20sudo%20su%20gdm%20-c%20%27gsettings%20%E2%80%A6%27%20%28or,root%2C%20so%20first%20become%20root%20then%20become%20gdm.
export DISPLAY=":0"
export XAUTHORITY="$1"
export XAUTHLOCALHOSTNAME="localhost"

gsettings set "$2" "$3" "$4"