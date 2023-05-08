#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

sudo apt install -y gnome-core gnome-tweaks terminator neofetch open-vm-tools-desktop gnome-shell-extensions \
gnome-shell-extension-ubuntu-dock gnome-shell-extension-manager gnome-shell-extension-gpaste gnome-shell-extension-desktop-icons-ng \
gnome-shell-extension-appindicator gir1.2-gtop-2.0 ubuntu-restricted-extras adwaita-icon-theme-full gnome-themes-standard libcanberra-gtk-module \
network-manager-config-connectivity-ubuntu network-manager-openvpn-gnome openvpn xinput network-manager-vpnc-gnome network-manager-vpnc vpnc vpnc-scripts \
network-manager-openconnect-gnome network-manager-openconnect openconnect gdebi asciinema libglib2.0-dev-bin seahorse seahorse-nautilus \
remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-vnc onboard yaru-theme-gtk yaru-theme-icon yaru-theme-sound

# Now let's make sure the snap store gets installed:
sudo snap install snap-store
sudo snap install postman

mkdir -p ~/.config
echo yes >> ~/.config/gnome-initial-setup-done

########## Setup Custom Script structure ##################
mkdir -p /usr/local/bin

# Add line to login-updates.sh if domain has been specified:

# Will now add line to login-updates to check if netlogon folder is available, and to run scripts if any found:
# Insert the line right above the line containing Set Ready
# sed -i "/Set Ready/i[ -f \"/mnt/netlogon/login.sh\" ] && bash /mnt/netlogon/login.sh\n" ~/.scripts/login-updates.sh

# Install the login-updates script file to /usr/local/bin:
sudo install ~/.scripts/login-updates.sh /usr/local/bin

# Place the login-updates.desktop file in correct folder for Ubuntu
# /etc/xdg/autostart will run the .desktop file in console ui login as well as xRDP login
sudo chown root.root ~/.scripts/runonce/login-updates.desktop
sudo chmod 644 ~/.scripts/runonce/login-updates.desktop
sudo mv ~/.scripts/runonce/login-updates.desktop /etc/xdg/autostart
#############################################################
# Add the onBoard onscreen keyboard to the startup:
mkdir -p "$HOME"/.config/autostart
cat <<"EOF"> "$HOME"/.config/autostart/onboard.desktop
[Desktop Entry]
Type=Application
Exec=/usr/bin/onboard
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en]=onBoard Keyboard
Name=onBoard Keyboard
Comment[en]=
Comment=
EOF

# Set onboard default configuration:
if [ -f ~/.scripts/runonce/onboard-defaults.conf ]; then
  sudo mkdir -p /etc/onboard
  sudo install ~/.scripts/runonce/onboard-defaults.conf /etc/onboard
fi

echo "05-install-desktop.sh executed" >> "$HOME"/.packer.txt