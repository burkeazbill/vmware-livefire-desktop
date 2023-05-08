#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
#
# The custom-login-screen will be displayed at the console login
# Additionally, if used on a VMware Horizon Desktop, this login screen will be presented
# during login/SSO setup
# During this build stage, we download and install the utility.
# After build user initial login, the utility will be executed once to set the background
#
# See if our custom login screen is in our Pictures folder of the build user's Home directory:
if [ -f "$HOME/Pictures/custom-login-screen.png" ]; then
  login_background_source="/usr/share/backgrounds/custom-login-screen.png"
  sudo cp "$HOME/Pictures/custom-login-screen.png" "$login_background_source"
  sudo chmod 644 "$login_background_source"
  # This 3rd party tool is no longer being used due to native commands available. See the 00-0-gnome-settings.sh for details
  #wget -qO - https://github.com/PRATAP-KUMAR/ubuntu-gdm-set-background/archive/main.tar.gz | tar zx --strip-components=1 ubuntu-gdm-set-background-main/ubuntu-gdm-set-background
  #sudo mv ubuntu-gdm-set-background /usr/local/bin
fi

echo "05-2-copy-custom-login-screen.sh executed" >> "$HOME"/.packer.txt