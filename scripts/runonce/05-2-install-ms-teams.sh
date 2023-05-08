#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing MS Teams" > ~/.status.txt
# Reference: https://docs.microsoft.com/en-us/microsoftteams/get-clients?tabs=Linux
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Microsoft Teams .................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Alternative method: sudo snap install teams
if [ ! -f /usr/share/keyrings/microsoft-prod.gpg ]; then
  # Required packages: (complete as part of my initial builds)
  # sudo apt install -y software-properties-common apt-transport-https wget ca-certificates gnupg2
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft-prod.gpg
  sudo install -o root -g root -m 644 microsoft-prod.gpg /usr/share/keyrings/
  rm -f microsoft-prod.gpg
fi
if [ ! -f /etc/apt/sources.list.d/teams.list ]; then
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/repos/ms-teams stable main" | sudo tee /etc/apt/sources.list.d/teams.list
  sudo apt update
fi
sudo apt install -y teams