#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

################# Now Add Docker:
# Alternate method: curl -fsSL https://get.docker.com -o get-docker.sh
# DRY_RUN=1 sh ./get-docker.sh

# Use the Built-In Ubuntu Repo:
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
sudo systemctl start docker
# Add user to docker group:
sudo usermod -aG docker "${USER}"
# Enable docker bash completion:
sudo curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

## Now setup files in /etc/profile.d to run at login to make sure facl is set...
# There is an issue with kind cluster creation with regards to nf_conntrack_max with newer linux kernels.
# The following helps address that issue by forcing a persistent update of the value across reboots
# Unfortunately, these two commands don't appear to work. Upon bootup, the value is set to 262144 and kind is unable to change it
#echo "net.netfilter.nf_conntrack_max=131072" | sudo tee -a /etc/sysctl.conf
# Now, make sure that is loaded upon boot:
#echo "nf_conntrack" | sudo tee -a /etc/modules
#
cat > /tmp/set-docker-kind.sh << "EOF"
#!/bin/bash
# getfacl can be used to check Access Control List on file
echo "Initializing..." > ~/.status.txt
sudo sysctl net/netfilter/nf_conntrack_max=131072 1>/dev/null
sudo setfacl -m user:"$USER":rw /var/run/docker.sock
sudo setfacl -m user:"$USER":rw /run/containerd
sudo setfacl -m user:"$USER":rw /run/containerd/containerd.sock
sudo setfacl -d -m user:"$USER":rw /run/containerd
# Let's also make sure the docker group has access to all three of these files
sudo setfacl -m group:docker:rw /var/run/docker.sock
sudo setfacl -m group:docker:rw /run/containerd
sudo setfacl -m group:docker:rw /run/containerd/containerd.sock
sudo setfacl -d -m group:docker:rw /run/containerd

sudo systemctl daemon-reload
EOF
sudo mv /tmp/set-docker-kind.sh /etc/profile.d/set-docker-kind.sh
echo "03-install-docker-kind.sh [docker] executed" >> "$HOME"/.packer.txt
# The following wget command retrieves the latest version number for docker-compose, install it
DOCKER_COMPOSE_VERSION=$(curl -L -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Enable bash completion for docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Display the version:
docker-compose version
echo "03-install-docker-kind.sh [docker-compose] executed" >> "$HOME"/.packer.txt
# Install Kind -- updated to get latest version !
KIND_VERSION=$(curl -L -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-$(uname)-amd64"
chmod 755 ./kind
sudo chown root.root ./kind
sudo mv ./kind /usr/local/bin
echo "$(kind --version) installed" >> "$HOME"/.packer.txt

echo "03-install-docker-kind.sh [kind] executed" >> "$HOME"/.packer.txt