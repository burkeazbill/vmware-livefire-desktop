#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

mkdir -p ~/.ssh
chmod 0700 ~/.ssh
echo "$SSH_PUBKEY" >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
echo "03-set-ssh-pubkey.sh executed" >> "$HOME"/.packer.txt