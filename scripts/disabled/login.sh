#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
# I have this file placed on my Domain controller, in the /sysvol/$REALM/scripts folder which is the /netlogon share
# My VMs check to see if /mnt/netlogon/login.sh is available, if so, they run this script at the end of their gnome login

# I've placed my lab CA Certificates in a public-shared folder
# that gets mounted to $HOME/net-shares/public-shared
mount=$HOME/net-shares/public-shared
# Setup some logging to a hidden file in the user's home directory
login_script_log=$HOME/.login.txt
date "+%Y-%m-%d" > "$login_script_log"

######### Certificate Management ###############
# Confirm that the "Certs" folder exists on the $mount
if [ -d "$mount/Certs" ]; then
  # Add the CA Certificates to Ubuntu's ca-certificates folder
  # All files ending in .cer or .crt will be copied:
  sudo cp -u "$mount"/Certs/*.c* /usr/local/share/ca-certificates | tee -a "$login_script_log"
else
  echo "$mount/Certs folder not found!" >> "$login_script_log"
fi
# Next, update ca-certs:
sudo update-ca-certificates

# Also make sure the Certs are trusted by Chromium based browsers: Chromium, Chrome, Brave, MS Edge:
# To check certs: openssl x509 -in <path to cert> -text
# Let's get Chrome to trust the CA issued certs
# Only attempt to run this command if the runonce folder exists:
if [ -d "/usr/local/share/ca-certificates/" ]; then
  echo "Processing certutil imports" > ~/.status.txt
  echo "Processing certutil imports" >> "$login_script_log"
  # The section below uses certutil to import the CA Certificates to the browser databases
  # libnss3-tools - provides: certutil
  # Make sure that certutil is already installed, if not, install it. If there is an error installing exit with status 1:
  if ! command -v certutil &> /dev/null
  then
    sudo apt install -y libnss3-tools
  fi
  # If Firefox installed using snap, the cert database gets stored in a directory path under ~/snap/firefox
  # otherwise, it is installed under ~/.mozilla/firefox
  # the following command identifies that folder and stores to $ff_db
  ff_db=$(dirname "$(find {$HOME/.mozilla,$HOME/snap} -print 2>/dev/null | grep 'firefox.*cert9.db')")
  for file in /usr/local/share/ca-certificates/*.c*
  do
    echo "Checking $file ..." >> "$login_script_log"
    if [ ! -f "$file" ]; then
      continue
    else
      echo "Processing file: $file" >> "$login_script_log"
      # The default database folder for Chromium browsers is $HOME/.pki/nssdb 
      certutil -d sql:"$HOME"/.pki/nssdb -A -t "CP,CP," -n "$(basename "$file")" -i "$file" >> "$login_script_log"
      [[ $? -eq 0 ]] && echo "Chrome/Edge Imported $file success!" >> "$login_script_log" || echo "Failed Chrome/Edge import $file" >> "$login_script_log"
      if [ -n "$ff_db" ]; then
        certutil -d sql:"$ff_db" -A -t "CP,CP," -n "$(basename "$file")" -i "$file" >> "$login_script_log"
        [[ $? -eq 0 ]] && echo "Firefox Imported $file success!" >> "$login_script_log" || echo "Failed Firefox import $file" >> "$login_script_log"
      fi
    fi
  done
fi
echo "=======================================================================" >> "$login_script_log"
echo -e "\nChrome/Edge/Chromium/Brave Trusted CA Certificates found in: $HOME/.pki/nssdb :" >> "$login_script_log"
certutil -L -d sql:"$HOME"/.pki/nssdb >> "$login_script_log"
echo "=======================================================================" >> "$login_script_log"
if [ -n "$ff_db" ]; then
  echo -e "\nFirefox Trusted CA Certificates found in: $ff_db :" >> "$login_script_log"
  certutil -L -d sql:"$ff_db" >> "$login_script_log"
  echo "=======================================================================" >> "$login_script_log"
fi
