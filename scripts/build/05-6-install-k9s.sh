#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing k9s         .....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

# The simplest option:
# curl -sS https://webinstall.dev/k9s | bash

# Release Binary:
curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep 'browser_download_url.*k9s_Linux_amd64' | cut -d '"' -f 4 | wget -i -
tar -zxvf k9s*.gz k9s
sudo install k9s /usr/local/bin
sudo rm -f k9*

# To uninstall: sudo apt remove slack-desktop
echo "05-6-install-k9s.sh executed" >> "$HOME"/.packer.txt