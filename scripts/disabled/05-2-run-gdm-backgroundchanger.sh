#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# NOTE: The install-gdm-backgroundchanger script should have been run before this script
#       ideally during the build stage as sudo cp is used to place the file in /usr/local/bin and 
#       copy the background file to the /usr/share/backgrounds folder
#
# See if our custom login screen is in the /usr/share/backgrounds directory:
login_background_source="/usr/share/backgrounds/custom-login-screen.png"
# Now, only run the background changer app if the custom login screen file actually exists
if [ -f $login_background_source ]; then
  # Make sure that the binary has been installed to /usr/local/bin and execute if found
  if ! command -v ubuntu-gdm-set-background &> /dev/null
  then
    echo "ubuntu-gdm-set-background not found in /usr/local/bin ! Not setting Login Background!" >> "$HOME"/.packer.txt
  else
    echo "Running ubuntu-gdm-set-background with this image: $login_background_source" >> "$HOME"/.packer.txt
    sudo /usr/local/bin/ubuntu-gdm-set-background --image "$login_background_source" 2>> "$HOME"/.packer.txt
    # In order to reset back to default: sudo update-alternatives --quiet --set gdm-theme.gresource /usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource    
  fi
else
  echo "$login_background_source not found! Not setting Login Background!"  >> "$HOME"/.packer.txt
fi
echo "05-2-run-gdm-backgroundchanger.sh executed" >> "$HOME"/.packer.txt