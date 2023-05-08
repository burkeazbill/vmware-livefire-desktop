#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Slack" > ~/.status.txt
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Slack       .....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"

# The following url is from :
#curl -L -o /tmp/slack.deb https://downloads.slack-edge.com/releases/linux/4.27.156/prod/x64/slack-desktop-4.27.156-amd64.deb
#sudo gdebi -n /tmp/slack.deb 
#sudo rm -f /tmp/slack.deb

# https://packagecloud.io/slacktechnologies/slack/install#manual-deb
if [ ! -f /usr/share/keyrings/slacktechnologies_slack.gpg ]; then
  sudo apt install -y wget gpg apt-transport-https
  curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey | gpg --dearmor > slacktechnologies_slack.gpg
  sudo install -o root -g root -m 644 slacktechnologies_slack.gpg /usr/share/keyrings/
  rm -f slacktechnologies_slack.gpg
fi
if [ ! -f /etc/apt/sources.list.d/slacktechnologies_slack.list ]; then
  echo "deb [signed-by=/usr/share/keyrings/slacktechnologies_slack.gpg] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee -a /etc/apt/sources.list.d/slacktechnologies_slack.list
  echo "# deb-src [signed-by=/usr/share/keyrings/slacktechnologies_slack.gpg] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee -a /etc/apt/sources.list.d/slacktechnologies_slack.list
fi
sudo apt update
sudo apt install -y slack-desktop
# Alternate install method:
# sudo snap install slack

# To uninstall: sudo apt remove slack-desktop