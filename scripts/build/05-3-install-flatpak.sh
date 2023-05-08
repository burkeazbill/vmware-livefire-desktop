#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Flatpak/Flathub" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Flatpak..........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "05-3-install-flatpak.sh executed" >> "$HOME"/.packer.txt