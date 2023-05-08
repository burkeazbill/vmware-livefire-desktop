#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
if ! command -v java &> /dev/null
then
    echo "java not found, installing..."
    sudo apt install -y openjdk-8-jdk
    echo export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" | sudo tee -a /etc/zsh/zshenv
fi
echo "05-2-install-openjdk-8-jdk.sh executed" >> "$HOME"/.packer.txt