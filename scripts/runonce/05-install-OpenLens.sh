#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# sudo not needed
echo "Installing OpenLens" > ~/.status.txt
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing OpenLens    .....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

# [^arm64] <- don't return the lines with arm64 before the .deb
# Only return the line that ends with .deb"
if [ ! -f /usr/bin/open-lens ]; then
  curl -s https://api.github.com/repos/MuhammedKalkan/OpenLens/releases/latest | grep 'browser_download_url.*amd64.deb"$' | cut -d '"' -f 4 | wget -i -
  sudo dpkg -i OpenLens*.deb
  rm -f OpenLens*.deb
fi
# Alternate method:
# snap install --classic kontena-lens
