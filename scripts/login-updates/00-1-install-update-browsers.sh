#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
# Install Microsoft Edge at Gnome login. For some reason, trying to install during the packer process
# Results in repo errors that abort the packer build. Doing it at Gnome login has produced consistent success
# without corrupting the apt repo lists
# TODO: Re-test these browser installs in the Build phase after desktop install. My Aug 5th, 2022 update of the syntax for repos should allow this to work now

mkdir -p ~/.local/share/applications

# If sudo is required in the rest of the script, check for it first
# and exit with non-zero if not sudo:
if sudo -l | grep -q -c apt ; then
  ################################## Install MS Edge #######################################
  if [ ! -f "/bin/microsoft-edge" ]; then
    echo "Installing MS Edge" > ~/.status.txt
    if [ ! -f /usr/share/keyrings/microsoft-prod.gpg ]; then
        sudo apt install -y wget gpg apt-transport-https
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft-prod.gpg
        sudo install -o root -g root -m 644 microsoft-prod.gpg /usr/share/keyrings/
        rm -f microsoft-prod.gpg
    fi
    if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
    fi
    sudo apt update
    sudo apt install -y microsoft-edge-stable

    # Now tell Edge NOT to prompt for keyring password upon launch
    cp /usr/share/applications/microsoft-edge.desktop ~/.local/share/applications
    sed -i 's/Exec=\/usr\/bin\/microsoft-edge-stable/& --password-store=basic --disable-gpu --disable-software-rasterizer/g' ~/.local/share/applications/microsoft-edge.desktop
    # NOTES: Edge stores bookmarks in this json file: ~/.config/microsoft-edge/Default/Bookmarks
  else
    # If Microsoft Edge is already installed, upgrade it if there is an available package:
    echo "Checking MS Edge Updates" > ~/.status.txt
    sleep 5
    sudo apt --only-upgrade install microsoft-edge-stable
  fi

  ################################## Install Chrome #######################################
  if [ ! -f "/bin/google-chrome" ]; then
    echo "Installing Google Chrome" > ~/.status.txt
    # sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" -y
    # sudo add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" -y # Google Chrome Repo
    # wget -q https://dl.google.com/linux/linux_signing_key.pub -O- | sudo apt-key add -
    # sudo apt update
    # sudo apt install -y google-chrome-stable
    if [ ! -f /usr/share/keyrings/google-chrome.gpg ]; then
      sudo apt install -y wget gpg apt-transport-https
      wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > google-chrome.gpg
      sudo install -o root -g root -m 644 google-chrome.gpg /usr/share/keyrings/
      rm -f google-chrome.gpg
    fi
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    fi
    sudo apt update
    sudo apt install -y google-chrome-stable

    # Now tell chrome NOT to prompt for keyring password upon launch, also disable GPU Hardware acceleration:
    # Source: https://support.google.com/chrome/thread/3452787?hl=en
    cp /usr/share/applications/google-chrome.desktop ~/.local/share/applications
    sed -i 's/Exec=\/usr\/bin\/google-chrome-stable/& --password-store=basic --disable-gpu --disable-software-rasterizer/g' ~/.local/share/applications/google-chrome.desktop
    # NOTES: Chrome stores bookmarks in this json file: ~/.config/google-chrome/Default/Bookmarks
  else
    # If Google Chrome is already installed, upgrade it if there is an available package:
    echo "Checking Google Chrome Updates" > ~/.status.txt
    sleep 5
    sudo apt --only-upgrade install google-chrome-stable
  fi
  ################################## Install Brave #######################################
  if [ ! -f "/bin/brave-browser" ]; then
    echo "Installing Brave Browser" > ~/.status.txt
    sudo apt install -y apt-transport-https curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    # Now tell chrome NOT to prompt for keyring password upon launch
    cp /usr/share/applications/brave-browser.desktop ~/.local/share/applications
    sed -i 's/Exec=\/usr\/bin\/brave-browser-stable/& --password-store=basic/g' ~/.local/share/applications/brave-browser.desktop
    # NOTES: Brave stores bookmarks in this json file: ~/.config/brave-browser/Default/Bookmarks
  else
    # If Brave is already installed, upgrade it if there is an available package:
    echo "Checking Brave Updates" > ~/.status.txt
    sleep 5
    sudo apt --only-upgrade install brave-browser
  fi
else
  exit 1
fi