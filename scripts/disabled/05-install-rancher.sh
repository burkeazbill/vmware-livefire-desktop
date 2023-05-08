#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
echo "Installing Rancher" > ~/.status.txt
# This alone currently does not work. Need to identify, test for, and install pre-requisites
#
#
#
#

curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo tee /etc/apt/sources.list.d/isv-rancher-stable.list
sudo apt update
sudo apt install -y rancher-desktop
