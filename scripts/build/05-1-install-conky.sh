#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing conky............................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
sudo apt install -y conky-all
mkdir -p ~/Pictures

if [ ! -f "$HOME/Pictures/Logo.png" ]; then
  wget -O ~/Pictures/Conky-Logo.png https://github.com/brndnmtthws/conky/raw/main/data/logo/conky-logotype-vertical-violet.png
  # Convert the logo to 200x200px so that it fits the Conky widge properly
  convert ~/Pictures/Conky-Logo.png -resize 200 ~/Pictures/Logo.png
fi
sudo cp "$HOME"/Pictures/Logo.png /usr/share/icons/my-logo.png
echo "To update the logo in the conky widge, update or replace /usr/share/icons/my-logo.png" >> "$HOME"/.packer.txt

mv ~/.scripts/runonce/.conkyrc ~/.conkyrc

# Now update the .conkyrc to make sure the correct NIC is referenced for the Internal IP address
# 1: is Loopback, 2: is the actual NIC, 3: is docker0
NIC_NAME=$(ip addr | grep "^2:" | cut -d":" -f 2 | xargs)
sed -i "s/ens160/$NIC_NAME/" ~/.conkyrc
echo "Initializing..." > ~/.status.txt
echo "-= Ubuntu Modern Apps =-" > ~/.conky-title.txt

# Creating the Autostart config and placing in correct folder for Ubuntu 20.04.x
sudo chown root.root ~/.scripts/runonce/conky.desktop
sudo chmod 644 ~/.scripts/runonce/conky.desktop
sudo mv ~/.scripts/runonce/conky.desktop /etc/xdg/autostart
echo "05-1-install-conky.sh executed" >> "$HOME"/.packer.txt