#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing NextCloud Client" > ~/.status.txt
############ NextCloud Client
# https://launchpad.net/~nextcloud-devs/+archive/ubuntu/client
#
# After adding the PPA to your system as described below, the client can be installed by issuing one of the following commands depending on your system:
# - Stock Ubuntu with Nautilus: sudo apt install nautilus-nextcloud
# - KDE Ubuntu with Dolphin: sudo apt install dolphin-nextcloud
# - Ubuntu MATE with Caja: sudo apt install caja-nextcloud
# - Ubuntu Mint with Nemo: sudo apt install nemo-nextcloud
# - Other, or if you don't want/need the file manager integration:
#      sudo apt install nextcloud-desktop
#
sudo add-apt-repository -y ppa:nextcloud-devs/client
sudo apt-get update
# If nautilus found, install client with nautlius integration
sudo apt install -y nautilus-nextcloud
# nextcloud-client-nautilus nautilus-script-manager
# Setup the autostart file:
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/com.nextcloud.desktopclient.nextcloud.desktop << "EOF"
[Desktop Entry]
Name=Nextcloud
GenericName=File Synchronizer
Exec="/usr/bin/nextcloud" --background
Terminal=false
Icon=Nextcloud
Categories=Network
Type=Application
StartupNotify=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=10
EOF
# Now copy the autostart to the /etc/skel template:
sudo mkdir -p /etc/skel/.config/autostart
sudo cp ~/.config/autostart/com.nextcloud.desktopclient.nextcloud.desktop /etc/skel/.config/autostart