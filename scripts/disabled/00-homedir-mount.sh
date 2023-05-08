#!/bin/bash
#
# PURPOSE:
# Make sure that each instructor has the .pam_mount.conf.xml file present in 
# their home directory and configured to mount their home drive from the file server

export login_script_log=$HOME/.login.txt
# Only process the following for Instructor Desktops (NOTE: Existing user home dir must already be created on file server with proper permissions)
[[ -f $HOME/.pam_mount.conf.xml ]] || touch "$HOME"/.pam_mount.conf.xml
if grep -Fq "my-h-drive" "$HOME"/.pam_mount.conf.xml
then
  echo "Home drive already defined in $HOME/.pam_mount.conf.xml" >> "$login_script_log"
else
  if [ -f /var/log/vmware/Environment.txt ]; then
    USER_ID=$(grep Broker_UserName < /var/log/vmware/Environment.txt | cut -d: -f2 | xargs)
    # Use the following CAT EOF method so that a variable may be substituted as the file is generated:
    cat <<EOF >~/.pam_mount.conf.xml
<?xml version="1.0" encoding="utf-8" ?>

<pam_mount>
  <volume options="nodev,nosuid" user="*" mountpoint="~/my-h-drive" path="${USER_ID}"  server="dc.lab.azbill.dev" fstype="cifs" />
</pam_mount>
EOF
  else
    echo "Not updating the .pam_mount.conf.xml file" >> "$login_script_log"
  fi
fi  
