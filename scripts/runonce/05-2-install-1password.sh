#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing 1Password" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing 1Password       .................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# First, see if 1password has been installed
if ! command -v 1password &> /dev/null
then
  # Commands from this page: https://support.1password.com/install-linux/
  # Add key for 1Password apt repository
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  # Add the apt repo:
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  # Add the debsig-verify policy:
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  # Install 1Password
  sudo apt update && sudo apt install -y 1password
  # Once complete, /usr/bin/1password will exist and icon will be available in launcher

  ## Alternate Method, using flatpak:
  # flatpak install -y https://downloads.1password.com/linux/flatpak/1Password.flatpakref
  # but then must be run vi launcher or this command: flatpak run com.onepassword.OnePassword
  # it does not provide a binary named 1password
fi
