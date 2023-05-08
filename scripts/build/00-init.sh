#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Starting Custom Script Runs 00-init.sh .....#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
#echo "SUDO_USER: " > "$HOME"/.packer.txt
echo "USER: ${USER}" >> "$HOME"/.packer.txt
echo "~:" ~ >> "$HOME"/.packer.txt
echo "HOME: $HOME" >> "$HOME"/.packer.txt

# Set zsh as default shell: - done in preseed-desktop.cfg
# chsh -s $(which zsh)
# Now make sure zsh is default for all newly created users:
sudo sed -i "s|DSHELL=.*|DSHELL=/bin/zsh|" "/etc/adduser.conf"
echo EXTRA_GROUPS="docker users brew" | sudo tee -a /etc/adduser.conf
echo ADD_EXTRA_GROUPS=1 | sudo tee -a /etc/adduser.conf
# Add build user to the "users" group:
sudo usermod -G users "${USER}"

# Add Burke's custom Aliases:
if [ ! -d "/etc/zsh" ]; then
  sudo mkdir -p /etc/zsh
fi
# Create a user's private local bin
mkdir -p "$HOME/.local/bin"
echo 'export PATH="$HOME/.local/bin:$PATH"' | sudo tee -a /etc/zsh/zshenv

# Provide the cwatch (color watch) script:

echo '#!/bin/bash' | sudo tee "$HOME/.local/bin/cwatch"
echo 'while true; do clear; echo Every 5 seconds: $@; echo; $@; sleep 5; done' | sudo tee -a "$HOME/.local/bin/cwatch"
sudo chmod +x "$HOME/.local/bin/cwatch"
echo "Install cwatch to $HOME/.local/bin (Burke's color watch bash script)" >> "$HOME"/.packer.txt

ubuntu_version="$(lsb_release -r | awk '{print $2}')";
major_version="$(echo $ubuntu_version | awk -F. '{print $1}')";

# Disable release-upgrades
# sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades;

# Disable systemd apt timers/services
if [ "$major_version" -ge "16" ]; then
  sudo systemctl stop apt-daily.timer;
  sudo systemctl stop apt-daily-upgrade.timer;
  sudo systemctl disable apt-daily.timer;
  sudo systemctl disable apt-daily-upgrade.timer;
  sudo systemctl mask apt-daily.service;
  sudo systemctl mask apt-daily-upgrade.service;
  sudo systemctl daemon-reload;
fi

# Disable periodic activities of apt to be safe
# cat <<EOF >/tmp/10periodic;
# APT::Periodic::Enable "0";
# APT::Periodic::Update-Package-Lists "0";
# APT::Periodic::Download-Upgradeable-Packages "0";
# APT::Periodic::AutocleanInterval "0";
# APT::Periodic::Unattended-Upgrade "0";
# EOF
# sudo mv /tmp/10periodic /etc/apt/apt.conf.d/10periodic
# # Clean packages
# sudo rm -rf /var/log/unattended-upgrades;
# sudo apt purge -y unattended-upgrades;

# Disable and remove splash screen
#sudo sed -i.bak 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/' /etc/default/grub
#echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a /etc/default/grub
#sudo update-grub
#####

# Update the package list
sudo apt update -y;

# Install some base packages:
# mlocate - provides: updatedb, locate
# net-tools -provides: netstat and more...
# libnss3-tools - provides: certutil
sudo apt install -y dialog gawk apt-utils apt-transport-https software-properties-common ca-certificates git ncdu net-tools \
  python3-pip python-is-python3 dconf-editor mlocate glimpse shellcheck tmux nfs-common cifs-utils smbclient libpam-mount sshfs \
  gnupg2 ffmpeg bat wget gpg expect unzip jq exa libnss3-tools open-vm-tools

sudo mkdir -p /etc/zsh
echo "alias bat='batcat --paging=never --theme=\"Solarized (dark)\"'"  | sudo tee -a /etc/zsh/zshrc
echo "alias bat='batcat --paging=never --theme=\"Solarized (dark)\"'"  | tee -a ~/.bashrc
echo "alias xls='exa --group-directories-first --group --time-style long-iso --icons --header'" | sudo tee -a /etc/zsh/zshrc

# Create nssdb certificate db folder structure
[ ! -d "$HOME/.pki/nssdb" ] && mkdir -p "$HOME"/.pki/nssdb;
# Create new (-N) nssdb certificate db with empty password in directory $HOME/.pki/nssdb
certutil -N --empty-password -d sql:"$HOME"/.pki/nssdb

# Edit pam_mount.conf.xml to allow user to specify own settings in ~/.pam_mount.conf.xml
# NOTE: Requires that the libpam-mount package be installed:
# Docs: https://manpages.ubuntu.com/manpages/jammy/man5/pam_mount.conf.5.html
# Delete the end comment line below the luserconf line in /etc/security/pam_mount.conf.xml
sudo sed -i "/luserconf/ {n;d}" /etc/security/pam_mount.conf.xml
# Delete the start comment line above the luserconf line:
# Since sed can't go back, we reverse the file with tac, operate on the output, then reverse again and pipe it 
#    back to the original file, overwriting the original contents
tac /etc/security/pam_mount.conf.xml | sed "/luserconf/ {n;d}" | tac | sudo tee /etc/security/pam_mount.conf.xml &> /dev/null

# Now place a template file in user home directory:
# Example values shown below based on Zentyal Domain Controller setup in this video series: https://www.youtube.com/watch?v=pme0LcVVQMA 
# mkdir -p ~/net-shares/{sysvol,public-shared,${USER}}
cat <<EOF >~/.pam_mount.conf.xml
<?xml version="1.0" encoding="utf-8" ?>

<pam_mount>
<!--
Example values shown below based on Zentyal Domain Controller setup in this video series: https://www.youtube.com/watch?v=pme0LcVVQMA 

<volume options="nodev,nosuid" user="*" mountpoint="/mnt/netlogon"              path="netlogon"       server="dc.lab.azbill.dev" fstype="cifs" />
<volume options="nodev,nosuid" user="*" mountpoint="~/net-shares/public-shared" path="public-shared"  server="dc.lab.azbill.dev" fstype="cifs" />
<volume options="nodev,nosuid" user="*" mountpoint="~/net-shares/%(USER)"       path="%(USER)"        server="dc.lab.azbill.dev" fstype="cifs" />
-->
</pam_mount>
EOF

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

# Upgrade all installed packages incl. kernel and kernel headers
sudo apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew";

# The auto-install doesn't fully utilize the free space
# Resize the logical volume and resize the filesystem to fully use it
# sudo lvresize -v -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
# sudo resize2fs -p /dev/mapper/ubuntu--vg-ubuntu--lv
# The above commands are commented becauase they have been moved to 
# the packer file: user-data.pkrtpl.hcl

# Configure a pre-shutdown script service:
sudo mv ~/.scripts/pre-shutdown.service /etc/systemd/system
sudo install ~/.scripts/pre-shutdown-script.sh /usr/local/bin
sudo systemctl enable pre-shutdown

if [ -n "${PRIVATE_DNS_IP}" ]; then
  echo "Private DNS IP has been specified ${PRIVATE_DNS_IP}, disabling systemd-resolved..." >> "$HOME"/.packer.txt
  # Since a Private DNS IP has been specified, disable default ubuntu resolve and setup resolv.conf
  sudo systemctl stop systemd-resolved
  sudo systemctl disable systemd-resolved
  sudo unlink /etc/resolv.conf

  echo nameserver "${PRIVATE_DNS_IP}" | sudo tee /etc/resolv.conf
  #
  # echo nameserver 1.1.1.1 | sudo tee -a /etc/resolv.conf
  if [ -n "${INTERNAL_DOMAIN_NAME}" ]; then
    echo search "${INTERNAL_DOMAIN_NAME}" | sudo tee -a /etc/resolv.conf
  fi
  sudo chattr +i /etc/resolv.conf
else
  # do something here
  echo "No Private DNS IP has been specified systemd-resolved is still enabled" >> "$HOME"/.packer.txt
  # Provide an alias to clear the local DNS cache - Syntax for Ubuntu 20.04
  # echo "alias clearcache='echo Clearing Cache... && sudo systemd-resolve --flush-caches && systemd-resolve --statistics'" | sudo tee -a /etc/zsh/zshrc
  # echo "alias clearcache='echo Clearing Cache... && sudo systemd-resolve --flush-caches && systemd-resolve --statistics'" | sudo tee -a /etc/bashrc
  # New syntax for Ubuntu 22.04:
  echo "alias clearcache='echo Clearing DNS Cache... && sudo resolvectl flush-caches && resolvectl statistics'" | sudo tee -a /etc/zsh/zshrc
  echo "alias clearcache='echo Clearing DNS Cache... && sudo resolvectl flush-caches && resolvectl statistics'" | sudo tee -a /etc/bashrc
fi

if [ -n "${PRIVATE_NTP_IP}" ]; then
  echo "NTP=${PRIVATE_NTP_IP}" | sudo tee -a /etc/systemd/timesyncd.conf
fi
sudo timedatectl set-ntp true 

# Fix/set Locale
if [ -n "${BUILD_LOCALE}" ]; then
  # Uncomment the specified build locale
  sudo sed -i "/^# ${BUILD_LOCALE}/s/^#//" /etc/locale.gen
  # Uncomment all English Locale's so they are available as well:
  sudo sed -i "/^# en_/s/^#//" /etc/locale.gen
  sudo locale-gen
fi

echo "00-init.sh executed" >> "$HOME"/.packer.txt
sudo reboot
