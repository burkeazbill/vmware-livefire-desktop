#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing xRDP + audio.....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

# Prepare xrdp folders so that everyone uses same files:
xrdp_shared="/usr/local/share/xrdp"
sudo mkdir -p $xrdp_shared
# Set group ownership to users:
sudo chown root.users $xrdp_shared
# Modify access control list to make sure that all users can read/write/execute
sudo chmod 775 $xrdp_shared
sudo setfacl -d -m group:users:rwx $xrdp_shared
sudo setfacl -m group:users:rwx $xrdp_shared
# Link current user:
ln -s $xrdp_shared ~/xrdp

# Prepare xorgxrdp folders so that everyone uses same files:
xorgxrdp_shared="/usr/local/share/xorgxrdp"
sudo mkdir -p $xorgxrdp_shared
# Set group ownership to users:
sudo chown root.users $xorgxrdp_shared
# Modify access control list to make sure that all users can read/write/execute
sudo chmod 775 $xorgxrdp_shared
sudo setfacl -d -m group:users:rwx $xorgxrdp_shared
sudo setfacl -m group:users:rwx $xorgxrdp_shared
# Link current user:
ln -s $xorgxrdp_shared ~/xorgxrdp

# Get xrdp-installer download URL:
script_url=$(curl https://c-nergy.be/products.html | grep xrdp-installer | cut -d'"' -f4)
echo xrdp-installer download url: "$script_url"
script_zip=$(echo "$script_url" | cut -d"/" -f6) ## Altnernate: # basename $script_url
script_name=${script_zip%.*} ## Alternate: # basename $script_zip .zip
script_file="$script_name".sh
wget "$script_url"
unzip "$script_zip"
chmod +x "$script_file"
# Modify the file to override auto-detect of desktop environment and resulting prompt.
# This build process is for Gnome, so tell the script to just use Gnome:
sed -i "s/cnt=.*/cnt=1/" "$script_file"
sed -i "s/menu=.*/menu='ubuntu'/" "$script_file"
# -s enables sound redirection
# -l customizes the login screen
# -c enables the custom installation, uses latest available xrdp package
./"$script_file" -s -c -l
rm -f ./"$script_name".*

# wget https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.4.3.zip
# unzip xrdp-installer-1.4.3.zip 
# chmod +x  xrdp-installer-1.4.3.sh
# sed -i "s/cnt=.*/cnt=1/" xrdp-installer-1.4.3.sh
# sed -i "s/menu=.*/menu='ubuntu'/" xrdp-installer-1.4.3.sh
# ./xrdp-installer-1.4.3.sh -s -c -l
# rm -f ./xrdp-installer-1.4.3.*

rm -f ./griffon_logo_xrdp.bmp

sudo sed -i "4s/^/gnome-extensions enable ubuntu-dock@ubuntu.com \n/" /etc/xrdp/startwm.sh
sudo sed -i "5s/^/gnome-extensions enable dash-to-panel@jderose9.github.com \n/" /etc/xrdp/startwm.sh
sudo sed -i "5s/^/gnome-extensions enable ubuntu-appindicators@ubuntu.com \n/" /etc/xrdp/startwm.sh
sudo sed -i "5s/^/gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com \n/" /etc/xrdp/startwm.sh

# It seems that the script above can results in some File manager, settings, font packages, and several other things  get removed...
sudo apt install -y nautilus-admin nautilus-font-manager p7zip-full fonts-cantarell fonts-noto-color-emoji \
                    gnome-font-viewer gnome-core xdg-desktop-portal-gnome gnome-shell-extension-desktop-icons-ng \
                    open-vm-tools-desktop gnome-control-center gvfs-fuse ntfs-3g sshfs xdg-desktop-portal-gtk xdg-desktop-portal fuse3

echo "05-2-install-xrdp.sh executed" >> "$HOME"/.packer.txt