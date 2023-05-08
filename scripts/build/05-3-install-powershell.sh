#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# If apt installs dont work for whatever reason, you could revert to using snap:
# Warning!!! snap installations work, but when running pwsh commands, shell returns with segmentation fault!
# sudo snap install powershell --classic
# Alternate method to install: https://www.how2shout.com/linux/how-to-install-powershell-on-ubuntu-22-04-lts/ 
echo
POWERSHELL_VERSION=$(curl -L -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/")
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing PowerShell $POWERSHELL_VERSION.....#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Prepare powershell folders so that everyone uses same modules:
ps_shared="/usr/local/share/powershell"
sudo mkdir -p $ps_shared
# Set group ownership to users:
sudo chown root.users $ps_shared
# Modify access control list to make sure that all users can read/write/execute
sudo chmod 775 $ps_shared
sudo setfacl -d -m group:users:rwx $ps_shared
sudo setfacl -m group:users:rwx $ps_shared

# Link current user:
mkdir -p ~/.local/share/
ln -s $ps_shared ~/.local/share/powershell

# Also link for root
sudo mkdir -p /root/.local/share/
sudo ln -s $ps_shared /root/.local/share/powershell
# Get the full url to the download file
deb_url=$(curl -L -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep 'browser_download_url.*deb_amd64.deb'  | cut -d '"' -f 4)
# Download the file
wget "$deb_url"
# Based on the URL, determine the file that was downloaded
deb_file=$(basename "$deb_url")
if [ -f "$deb_file" ]; then
  # Install the file
  sudo gdebi -n "$deb_file"
  # Remove the installer file
  rm -f "$deb_file"
else
  echo "WARNING: Unable to find $deb_file for installation!!!" >> "$HOME"/.packer.txt
fi

echo "03-install-powershell.sh executed" >> "$HOME"/.packer.txt