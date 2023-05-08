#!/bin/bash -eu
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing GitHub CLI             ..........#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

curl -L -s https://api.github.com/repos/cli/cli/releases/latest | grep 'browser_download_url.*linux_amd64.deb' | cut -d '"' -f 4 | wget -i -
sudo gdebi -n gh_*.deb
# export GH_VERSION=$(curl -L -s https://api.github.com/repos/cli/cli/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/")
# Show version based on filename:
# echo GitHub CLI Version: v$(ls gh*.deb | cut -d"_" -f2)
rm -Rf gh_*.deb
GH_VERSION=$(gh --version | tail -n 1 | cut -d"/" -f8)
/bin/echo -e "\e[38;5;39m#====================================================#\e[0m"
/bin/echo -e "\e[38;5;39m# GitHub CLI $GH_VERSION installed!          ........#\e[0m"
/bin/echo -e "\e[38;5;39m#====================================================#\e[0m"

echo "03-install-github-cli.sh executed, installed gh $GH_VERSION" >> "$HOME"/.packer.txt