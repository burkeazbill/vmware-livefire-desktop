#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Zoom" > ~/.status.txt
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Zoom        .....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

# The following url is from :
curl -L https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
sudo gdebi -n /tmp/zoom_amd64.deb 
sudo rm -f /tmp/zoom_amd64.deb
# Alternate install method:
# sudo snap install zoom-client