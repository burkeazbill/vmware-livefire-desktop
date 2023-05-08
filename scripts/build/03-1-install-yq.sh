#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# Install yq (similar to jq, but for yaml): https://github.com/mikefarah/yq
#export YQ_VERSION=$(curl -L -s https://api.github.com/repos/mikefarah/yq/releases | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
#sudo wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_`uname -s | tr '[:upper:]' '[:lower:]'`_amd64 -O /usr/local/bin/yq
#sudo chmod +x /usr/local/bin/yq
#yq version

# Apt repo, but uses deprecated apt-key method
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6657DBE0CC86BB64
# sudo add-apt-repository ppa:rmescandon/yq -y
# The instructions say to do as above, but that results in apt warnings, the instructions below do not result in warnings:

export GNUPGHOME=$(mktemp -d)
gpg --keyserver keyserver.ubuntu.com --recv-keys 6657DBE0CC86BB64
gpg -ao "$GNUPGHOME"/rmescandon.asc --export 6657DBE0CC86BB64
cat "$GNUPGHOME"/rmescandon.asc | sudo gpg --dearmor --output=/usr/share/keyrings/rmescandon.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/rmescandon.gpg] https://ppa.launchpadcontent.net/rmescandon/yq/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/rmescandon-ubuntu-yq-jammy.list
echo "#deb-src [arch=amd64 signed-by=/usr/share/keyrings/rmescandon.gpg] https://ppa.launchpadcontent.net/rmescandon/yq/ubuntu/ jammy main" | sudo tee -a /etc/apt/sources.list.d/rmescandon-ubuntu-yq-jammy.list

sudo apt update
sudo apt install yq -y
# if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
#   /home/linuxbrew/.linuxbrew/bin/brew install yq
# else
#   echo "Could not locate brew in /home/linuxbrew/.linuxbrew/bin/brew, yq not installed!" >> "$HOME"/.packer.txt  
# fi
echo "03-install-yq.sh executed" >> "$HOME"/.packer.txt