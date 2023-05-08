#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# If sudo is required in the rest of the script, check for it first
# and exit with non-zero if not sudo:
#if sudo -l | grep -q -c apt ; then
  echo "Installing Shutter" > ~/.status.txt
  echo
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing Shutter..........................#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  echo
  sudo apt install -y shutter

# else
#   exit 1
# fi