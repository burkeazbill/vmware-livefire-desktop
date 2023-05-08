#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

  echo "Installing VLC and OBS" > ~/.status.txt
  echo
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing VLC and OBS     .................#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  echo
  sudo apt install -y vlc obs-studio
