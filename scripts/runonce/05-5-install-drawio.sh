#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Draw.io" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Draw.io .........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

curl -s https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | grep 'browser_download_url.*\.deb' | cut -d '"' -f 4 | wget -i -
sudo gdebi -n ./drawio*.deb
# Cleanup:
rm -f drawio*.deb