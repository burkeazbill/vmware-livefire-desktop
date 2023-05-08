#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

cat > ~/disable-password-prompts.pkla << "EOF"
[Allow Package Management all Users]
Identity=unix-user:*
Action=*
ResultAny=yes
ResultActive=yes
ResultInactive=yes
EOF

sudo chown root.root ~/*.pkla
sudo chmod 664 ~/*.pkla
sudo mv ~/*.pkla /etc/polkit-1/localauthority/50-local.d/
echo "03-disable-pw-prompts.sh executed" >> "$HOME"/.packer.txt