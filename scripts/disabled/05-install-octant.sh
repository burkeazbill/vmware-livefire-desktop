#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# VMware has ended development of Octant as of 2022

echo "Installing Octant" > ~/.status.txt
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Octant      .....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

curl -s https://api.github.com/repos/vmware-tanzu/octant/releases/latest | grep 'browser_download_url.*64bit\.deb' | cut -d '"' -f 4 | wget -i -
sudo gdebi -n ./octant*-64bit.deb
sudo rm -f ./octant*-64bit.deb
