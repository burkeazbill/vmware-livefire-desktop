#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#==================================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Allowing all users to run certain sudo commands .#\e[0m"
/bin/echo -e "\e[38;5;39m#==================================================#\e[0m"
echo
echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/apt* , /usr/bin/chsh , /usr/bin/install, /usr/bin/dpkg , /usr/bin/gdebi , /usr/bin/resolvectl , /usr/bin/certutil' | sudo tee /etc/sudoers.d/all-can-run-cmds
echo 'ALL ALL=(ALL:ALL) NOPASSWD: ALL'  | sudo tee -a /etc/sudoers.d/all-can-run-cmds
sudo chmod 440 /etc/sudoers.d/all-can-run-cmds
