#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Skype" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Skype for Linux .................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
#wget -O /tmp/skypeforlinux-64.deb https://go.skype.com/skypeforlinux-64.deb
#sudo gdebi -n /tmp/skypeforlinux-64.deb
#sudo rm /tmp/skypeforlinux-64.deb

# Now fix the gpg key storage: https://askubuntu.com/questions/1398344/apt-key-deprecation-warning-when-updating-system
# Get the export key by looking at the last 8 characters of the pub line in this output for Skype:
# sudo apt-key list skype

#sudo apt-key export DF7587C3 | sudo gpg --dearmour -o /usr/share/keyrings/skypeforlinux.gpg
#sudo apt-key del DF7587C3
#sudo mv /etc/apt/sources.list.d/skype-stable.list /root/skype-stable.list

# Retrieve the SKype GPG key from the repo and add it to /usr/share/keyrings:
curl -s https://repo.skype.com/data/SKYPE-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/skypeforlinux.gpg
# Now generate new file with the signed-by and location of the key:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/skypeforlinux.gpg] https://repo.skype.com/deb stable main' | sudo tee /etc/apt/sources.list.d/skype-stable.list
# Prevent the skype-stable.list file from being overwritten/modified.
# Whenever skype is installed/reinstalled, the deb package installs a bad copy of the .list file that does not have the signed-by attribute!
sudo chattr +i /etc/apt/sources.list.d/skype-stable.list
sudo apt update && sudo apt install -y skypeforlinux
  
# Alternate method: snap install skype