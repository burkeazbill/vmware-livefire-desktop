#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing LibreOffice" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing LibreOffice     .................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# First, make sure flathub has been installed
if ! command -v flathub &> /dev/null
then
  sudo apt install -y flatpak gnome-software-plugin-flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
# Now install LibreOffice
flatpak install -y flathub org.libreoffice.LibreOffice