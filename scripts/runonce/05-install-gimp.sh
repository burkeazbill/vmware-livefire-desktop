#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
runonce_log="$HOME/.scripts/runonce/.runonce.log"


  echo "Installing Gimp" > ~/.status.txt
  echo "Installing Gimp" >> "$runonce_log"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing Gimp, gpaint, and Krita..........#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

  sudo apt install -y gimp gimp-data-extras gimp-help-en gimp-lensfun gimp-plugin-registry gimp-texturize gpaint krita
