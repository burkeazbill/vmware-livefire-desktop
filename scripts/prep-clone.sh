#!/bin/bash
# If/when this script is used for testing/cleanup, be sure to unmount any shares before proceeding:
# For example: 
# sudo umount /home/builduser/attendee-share
echo "Clearing out /etc/skel folder..."
rm -Rf /etc/skel

echo "Cleaning up logs and old files..."
stat -t /var/log/builduser-*.log >/dev/null 2>&1 && truncate -s0  /var/log/builduser-*.log
stat -t /var/log/cloud* >/dev/null 2>&1 && truncate -s0  /var/log/cloud*
stat -t /var/log/builduser-imc/toolsDeployPkg.log >/dev/null 2>&1 && truncate -s0 /var/log/builduser-imc/toolsDeployPkg.log
rm -Rf /var/log/sssd/*
rm -Rf /etc/netplan/50*
rm -Rf /etc/netplan/99*
rm -Rf /etc/netplan/*.BeforeVMwareCustomization
rm -Rf /tmp/*.log
rm -Rf /tmp/guest.customization.stderr
#rm -Rf /var/log/.vmware-deploy.ERRORED
rm -Rf /.marker*.txt
# vCD specific, commenting out for general use
# rm -Rf /root/.customization
# rm -Rf /root/console-cust.log
# stat -t /root/vcd*.log >/dev/null 2>&1 && truncate -s0  /root/vcd*.log

echo "Cleaning up builduser folder..."
stat -t /home/builduser/.zcompdum* >/dev/null 2>&1 && rm /home/builduser/.zcompdum* || echo "No .zcompdump files to delete"
stat -t /home/builduser/.xorgxrdp.10.lo* >/dev/null 2>&1 && rm /home/builduser/.xorgxrdp.10.lo* || echo "No .xorgxrdp.10.lo* files to delete"
stat -t /home/builduser/.xsession* >/dev/null 2>&1 && rm /home/builduser/.xsession* || echo "No .xsession files to delete"
stat -t /home/builduser/.wget-hsts >/dev/null 2>&1 && rm /home/builduser/.wget-hsts || echo "No .wget-hsts file to delete"
stat -t /home/builduser/publicip >/dev/null 2>&1 && rm /home/builduser/publicip || echo "No publicip file to delete"
stat -t /home/builduser/.publicip >/dev/null 2>&1 && rm /home/builduser/.publicip || echo "No .publicip file to delete"
stat -t /home/builduser/.login.txt >/dev/null 2>&1 && rm /home/builduser/.login.txt || echo "No .login.txt file to delete"
stat -t /home/builduser/.config/Code/machineid >/dev/null 2>&1 && rm /home/builduser/.config/Code/machineid || echo "No machineid file to delete"

# Cache and Config Directory cleanup, no need to stat as check since the -f forces whether it exists or not
rm -Rf /home/builduser/CachedExtensionVSIXs
rm -Rf /home/builduser/.config/Code/logs/*
rm -Rf /home/builduser/.config/Code/Cache/Cache_Data/*
rm -Rf /home/builduser/.config/Code/CachedData/*
rm -Rf /home/builduser/.config/Code/Backups/*
rm -Rf /home/builduser/.config/Code/GPUCache/*
rm -Rf /home/builduser/.config/Code/Code\ Cache/*
rm -Rf /home/builduser/.config/Code/Crash\ Reports/
rm -Rf /home/builduser/.config/Code/CachedExtensionVSIXs/*
rm -Rf /home/builduser/.config/Code/User/workspaceStorage/*
rm -Rf /home/builduser/.config/Code/exthost\ Crash\ Reports/
rm -Rf /home/builduser/.config/Slack/Cache/Cache_Data/*
rm -Rf /home/builduser/.config/Slack/Service\ Worker/CacheStorage/*
rm -Rf /home/builduser/.config/microsoft-edge/Default/Service\ Worker/CacheStorage/*
rm -Rf /home/builduser/.cache
rm -Rf /home/builduser/.kube/cache
rm -Rf /home/builduser/.npm/_cacache
cat /dev/null > /home/builduser/.zsh_history
cat /dev/null > /home/builduser/.bash_history
echo "Initializing..." > /home/builduser/.status.txt

if [ -d "/home/builduser/.pcsc10" ]; then
  rm -Rf /home/builduser/.pcsc10
fi
if [ -d "/home/builduser/thinclient_drives" ]; then
  rmdir /home/builduser/thinclient_drives
fi
if [ -d "home/builduser/User" ]; then
  rm -Rf /home/builduser/User
fi

# When updating the Horizon Agent, the common-session file gets reset. This line will
# restore a known good config with the .GOOD extension back to the proper settings
# Note, once you have the correct config, make a backup copy with the .GOOD extension 
# so that this script can restore after agent updates
if [ -f "/etc/pam.d/common-session.GOOD" ]; then
  cp -f /etc/pam.d/common-session.GOOD /etc/pam.d/common-session
fi

echo "Cleanup snap installations as needed..."
echo "Snaps usage before: $(du -hs /var/lib/snapd/snaps | cut -c -5)"
echo "Disabled and Old snaps wasting space: "
snap list --all | awk '/disabled/{print $1, $3}'
echo "Cleaning those up now..."
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done
echo "Snaps usage after: $(du -hs /var/lib/snapd/snaps | cut -c -5)"
######################
echo "cleaning up cache, logs, and history"
sudo apt clean all
sudo apt autoremove --purge -y

echo "Copying hidden files and directories from /home/builduser to /etc/skel"
cp -R /home/builduser /etc/skel
chmod 755 /etc/skel
chown root:root -R /etc/skel
journalctl --rotate
journalctl --vacuum-time=1s &> /dev/null
echo "make sure to run bleachbit for extra cleanup!"
# echo "Cleaning up any previous sssd cache..."
# This section only required if you want to cleanup an sssd configured, domain joined vm
# systemctl disable sssd
# sss_cache -E
# rm -Rf /var/lib/sss/mc/*
# rm -Rf /var/lib/sss/db/*
# rm -Rf /var/lib/sss/pubconf/*
# rm -Rf /etc/krb5.keytab
echo "Clearing machine-id"
echo -n > /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
echo "Machine-id: $(cat /etc/machine-id)"

cloud-init clean
touch /etc/cloud/cloud-init.disabled
history -c
echo -n > /root/.zsh_history
echo -n > /root/.bash_history
# cloud-init status
echo "complete"