#!/bin/bash

 if [ ! -f vsphere.auto.pkrvars.hcl ]; then 
   # TODO - Copy the sample file, then prompt user for inputs. Update file based on inputss
   echo "You must specify your vsphere packer variables. Please copy"
   echo "variables.auto.pkrvars.hcl.example to variables.auto.pkrvars.hcl"
   echo "and update to match your environment."
   exit 1
 fi

if [ ! -f common.auto.pkrvars.hcl ]; then
   # TODO - Copy the sample file, then prompt user for inputs. Update file based on inputss
   echo "You must specify your common packer variables. Please copy"
   echo "common.auto.pkrvars.hcl.example to common.auto.pkrvars.hcl"
   echo "and update to match your environment."
   exit 1
 fi

if [ ! -d "MesloLGSNF" ]; then
  # The Nerd Fonts are downloaded into this directory. Caching a local copy here allows for multiple re-builds without re-downloading every time!
  # They are used for the oh-my-zsh and powerlevel10k configuration, and set as the
  # default font for Visual Studio Code, Terminal, and Terminator
  # They are used in the 03-1-install-omzsh.sh, 05-3-install-vs-code.sh, and 05-0-install-desktop.sh scripts
  mkdir -p MesloLGSNF
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P 'MesloLGSNF'
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P 'MesloLGSNF'
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P 'MesloLGSNF'
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P 'MesloLGSNF'
fi

if [ ! -d "./output" ]; then
  mkdir -p output
fi

### Build a Ubuntu Server 22.04 LTS Template for VMware vSphere. ###
echo "Building a Ubuntu Server 22.04 LTS Template for VMware vSphere..."

### Initialize HashiCorp Packer and required plugins. ###
echo "Initializing HashiCorp Packer and required plugins..."
packer init "./"

# DAILY_ISO_CHECKSUM=`curl https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS | grep live-server-amd64.iso | awk '{print $1}'`
# ISO_CHECKSUM=`curl https://releases.ubuntu.com/jammy/SHA256SUMS | grep live-server-amd64.iso | awk '{print $1}'`
# if [ `uname -s` == "Darwin" ]; then
#   sed -i "" "s/iso_checksum            = .*/iso_checksum            = \"sha256:$ISO_CHECKSUM\"/" "variables.auto.pkrvars.hcl"
# else
#   sed -i "s/iso_checksum = .*/iso_checksum = \"sha256:$ISO_CHECKSUM\"/" "variables.auto.pkrvars.hcl"
# fi
### Start the Build. ###
echo "Starting the build...."
# PACKER_LOG=1 packer build -force --on-error="abort" \
#       -var-file="./variables.pkr.hcl" \
#       -var-file="./vsphere.auto.pkrvars.hcl" \
#       -var-file="./common.auto.pkrvars.hcl" \
#       -var-file="./linux-ubuntu.auto.pkrvars.hcl" \
#       "./linux-ubuntu.pkr.hcl"
PACKER_LOG=1 packer build --on-error="abort" -force "./"
### All done. ###
echo "Done."
echo "Log into the VM as the build user and wait for the Desktop Status to show READY"
echo "Next, perform any/all final adjustments, including:"
echo "- Adjust autostart of app(s)"
echo "- Change On Screen Keyboard theme and configuration"
echo "- Join to Domain"
echo "- Configure Horizon Agent"
echo "- Once all of that is done, logout of the UI"
echo "- SSH to the desktop, then execute: sudo /root/prep-clone.sh"
echo "- Now shutdown the machine, take a snapshot, and play"