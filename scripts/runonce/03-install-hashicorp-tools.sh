#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Hashicorp Tools" > ~/.status.txt
# This curl command and apt-key add - are the old way, result in WARNING on Ubuntu 22.04
#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
#sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# Here's the newer way
# References: https://github.com/hashicorp/terraform/issues/30911 
wget --no-verbose --output-document=- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --output=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release --codename --short) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update 
sudo apt install -y packer vagrant vagrant-sshfs vault terraform nomad consul
