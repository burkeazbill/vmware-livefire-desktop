#!/bin/bash -e
#
# For details and documentation, visit: https://github.com/vaniacer/sshto
#

curl -s https://raw.githubusercontent.com/vaniacer/sshto/master/sshto -o /tmp/sshto
sudo install /tmp/sshto /usr/local/bin/sshto

# Now, provide a properly formatted example ssh config file:
mkdir -p "$HOME"/.ssh
cat <<EOF > "$HOME"/.ssh/config
# SSH Config File Example:
# Set Defaults:
Host *
ForwardAgent no
ForwardX11 no
ForwardX11Trusted yes
User root
Port 22
ServerAliveInterval 60
ServerAliveCountMax 60

Host *.example.local
User root
Port 22
IdentityFile ~/.ssh/example_local_key

#Host DUMMY #Internal Lab Hosts#

Host vpodrouter #vPod Router
HostName 192.168.100.1
User root
Port 22
# Since IdentityFile is not specified, will default to using ~/.ssh/id_rsa
    
Host jumpbox # Lab Jumpbox
User root
HostName 192.168.100.99
Port 22
IdentityFile ~/.ssh/jumpbox_rsa

#Host DUMMY #External Hosts#

# Login to internal lan server at 192.168.1.251 via our public us office ssh based gateway using #
# $ ssh officegateway #
Host officegateway #Connect via Office Gateway
HostName 192.168.1.251
User officeuser
ProxyCommand  ssh officeuser@office.gw.example.com nc %h %p 2> /dev/null

# Proxy Server #
# Forward all local port 3128 traffic to port 3128 on the remote vps.example.com server #
# $ ssh -f -N  proxytunnel #
Host proxytunnel #Use Proxy Tunnel 
HostName vps-01.example.com
User proxyuser
IdentityFile ~/.ssh/vps.example.com.key
LocalForward 3128 127.0.0.1:3128
EOF

echo "03-Install-sshto.sh executed" >> "$HOME"/.packer.txt