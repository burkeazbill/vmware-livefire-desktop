#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Initializing GDM Login Screen Settings      #\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

echo "Updating Login Screen" > ~/.status.txt

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


# Try to do some GDM settings as the gdm user:
# dbus-x11 is required for the commands to run as the gdm user
sudo apt install -y dbus-x11
# Prepare the current Xauthority-file for use by the gdm account:
cp "$XAUTHORITY" /tmp/.Xauthority
sudo chown gdm:root /tmp/.Xauthority
# Prepare script to load ENV variables for gdm account:
chmod 755 "$HOME"/.scripts/gset.sh
cp "$HOME"/.scripts/gset.sh /tmp
# Configure the Login Screen -- SPECIAL steps required - must be done as gdm user
# NOTE: If you specify a background color then the background-picture-uri is ignored
if [ -f "$login_background_source" ]; then
  sudo -u gdm /tmp/gset.sh /tmp/.Xauthority com.ubuntu.login-screen background-picture-uri "$login_background_source"
  sudo -u gdm /tmp/gset.sh /tmp/.Xauthority com.ubuntu.login-screen background-size 'auto'
else
  sudo -u gdm /tmp/gset.sh /tmp/.Xauthority com.ubuntu.login-screen background-color '#234f79'
fi

# background-size: 
# --- auto - image displayed in original size. 
# --- cover - resize the image to cover the entire container (even if stretch/cut-off)
# --- contain - resize the image to make sure the image is fully visible

# Commented vaules are showing default values:
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen allowed-failures 3
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen disable-restart-buttons false
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen enable-fingerprint-authentication true
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen enable-password-authentication true
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen enable-smartcard-authentication true
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen fallback-logo ''
# The following icon shows up BENEATH the username box on the login screen:
# sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen logo '/usr/share/icons/my-logo.png'
sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen banner-message-enable false
sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen banner-message-text 'Horizon Users: SSO will auto-login shortly.'
sudo -u gdm /tmp/gset.sh /tmp/.Xauthority org.gnome.login-screen disable-user-list true
