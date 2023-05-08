#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

sudo rm -f /etc/apt/sources.list.d/archive_*

# Tell systemd not to start rpc-svcgssd as per: https://help.univention.com/t/failed-rpc-security-service-for-nfs-server-after-4-3-upgrade/8196
systemctl mask rpc-svcgssd.service

# Disable Error Reporting Crash popups
sudo apt purge -y apport
# Make sure the build user home and subdirs is owned by the build user
sudo chown -R "${USER}"."${USER}" "$HOME"

# Cleanup apt
sudo apt clean all
sudo apt autoremove --purge -y

if [ -f ~/.scripts/runonce/np-update.py ]; then
  sudo python ~/.scripts/runonce/np-update.py
  mv ~/.scripts/runonce/np-update.py ~/.scripts/runonce/ran
fi
if [ -f "$HOME"/.scripts/prep-clone.sh ]; then
  # Update the script with the correct build user home
  sed -i "s|/home/builduser|$HOME|" "$HOME"/.scripts/prep-clone.sh
  chmod +x "$HOME"/.scripts/prep-clone.sh
  sudo mv "$HOME"/.scripts/prep-clone.sh /root/prep-clone.sh
fi
if [ -f "$HOME"/.scripts/domain-join-sssd.sh ]; then
  sudo mv "$HOME"/.scripts/domain-join-sssd.sh /root/domain-join-sssd.sh
fi

echo "99-reset-home-owner executed" >> "$HOME"/.packer.txt