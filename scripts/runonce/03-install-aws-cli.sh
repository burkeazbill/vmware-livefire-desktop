#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# no sudo needed
echo "Installing AWS CLI" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing AWS CLI..........#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# Get the aws cli binaries
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# Unzip it
unzip awscliv2
# Install it
sudo ./aws/install
aws --version
rm -Rf aws*

AWS_VERSION=$(aws --version | cut -d"/" -f2 | cut -d" " -f1)

rm -Rf tce-linux-amd64*
/bin/echo -e "\e[38;5;39m#====================================================#\e[0m"
/bin/echo -e "\e[38;5;39m# AWS CLI $AWS_VERSION installed! ...................#\e[0m"
/bin/echo -e "\e[38;5;39m#====================================================#\e[0m"
