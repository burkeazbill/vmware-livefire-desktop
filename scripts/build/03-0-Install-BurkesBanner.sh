#!/bin/bash -e
curl -s https://raw.githubusercontent.com/burkeazbill/terminal-banners/main/.banner.rc -o "$HOME"/.banner.rc
curl -s https://raw.githubusercontent.com/burkeazbill/terminal-banners/main/.banner.apps.rc -o "$HOME"/.banner.apps.rc

echo "03-Install-BurkesBanner.sh executed" >> "$HOME"/.packer.txt