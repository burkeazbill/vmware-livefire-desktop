#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing kubectl .........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Install Kubernetes CLI - kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin
rm kubectl
kubectl version --client=true -o json | grep gitVersion | sed 's/gitVersion/kubectl version/'

# Add Kubernetes bash completion:
echo 'source <(kubectl completion bash)' | sudo tee -a /etc/bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl

# Add kubernetes zsh completion:
echo 'source <(kubectl completion zsh)' | sudo tee -a /etc/zsh/zshrc
# the k alias will go to kubecolor down below instead of directly to kubectl
# echo 'alias k=kubectl' | sudo tee -a /etc/zsh/zshrc
# echo 'complete -F __start_kubectl k' | sudo tee -a /etc/zsh/zshrc
echo "export KUBE_EDITOR='code --extensions-dir /usr/local/share/code-extensions --wait'" | sudo tee -a /etc/zsh/zshenv
echo "03-install-kube-dev-cli-tools.sh [kubectl] executed" >> "$HOME"/.packer.txt

echo
KUBECOLOR_VERSION=$(curl -L -s https://api.github.com/repos/hidetatz/kubecolor/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/")
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Kubecolor $KUBECOLOR_VERSION.....#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
curl -L -s https://api.github.com/repos/hidetatz/kubecolor/releases/latest | grep 'browser_download_url.*Linux_x86_64' | cut -d '"' -f 4 | wget -i -
tar -zxvf kubecolor*.gz kubecolor
sudo install kubecolor /usr/local/bin
rm -f kubecolor*.gz kubecolor
echo 'alias k=kubecolor' | sudo tee -a /etc/zsh/zshrc
echo 'compdef kubecolor=kubectl' | sudo tee -a /etc/zsh/zshrc
echo 'compdef k=kubectl' | sudo tee -a /etc/zsh/zshrc
# Display kubecolor version using CLI
kubecolor --kubecolor-version
echo "03-install-kube-dev-cli-tools.sh [kubecolor] executed, kubecolor version: $KUBECOLOR_VERSION" >> "$HOME"/.packer.txt

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing mergekube and remkube............#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
curl -fsSL https://raw.github.com/burkeazbill/MergekubeRemkube/main/install.sh | bash
if [ -d MergekubeRemkube ]; then
  rm -Rf MergekubeRemkube
fi
echo "03-install-kube-dev-cli-tools.sh [Burke's mergekube/remkube] executed" >> "$HOME"/.packer.txt

echo
/bin/echo -e "\e[38;5;39m#===============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing carvel tools (https://carvel.dev)..#\e[0m"
/bin/echo -e "\e[38;5;39m# ytt, imgpkg, kbld, kapp, kwt, vendir, kctrl ..#\e[0m"
/bin/echo -e "\e[38;5;39m#===============================================#\e[0m"
echo
# Install Carvel tools: (used for TKG 1.2+)
# Must run as root (not just sudo) in order to install all tools correctly:
# To get around that, modify the mv and chmod lines of the file to be preceeded with sudo 
curl -L https://carvel.dev/install.sh > /tmp/install-carvel.sh
chmod +x /tmp/install-carvel.sh
sed -i "s/  mv/  sudo mv/g" /tmp/install-carvel.sh
sed -i "s/  chmod/  sudo chmod/g" /tmp/install-carvel.sh
bash /tmp/install-carvel.sh

# Add kapp auto completion to zsh
echo "source <(kapp completion zsh) &> /dev/null" | sudo tee -a /etc/zsh/zshrc
echo "03-install-kube-dev-cli-tools.sh [carvel] executed" >> "$HOME"/.packer.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing kubectx & kubens.................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
### kubectx and kubens
## Repo: <https://github.com/ahmetb/kubectx#installation>
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
# For zsh completion:
mkdir -p ~/.oh-my-zsh/completions
chmod -R 755 ~/.oh-my-zsh/completions
ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
# For Bash completion:
if ! command -v pkg-config &> /dev/null
then
    sudo apt install -y pkg-config
fi
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
sudo ln -sf /opt/kubectx/completion/kubens.bash "$COMPDIR"/kubens
sudo ln -sf /opt/kubectx/completion/kubectx.bash "$COMPDIR"/kubectx
echo "03-install-kube-dev-cli-tools.sh [kubectx / kubens] executed" >> "$HOME"/.packer.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Helm 2...........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Get HELM 2
curl -L https://git.io/get_helm.sh | sudo bash
sudo mv /usr/local/bin/helm /usr/local/bin/helm2
# helm2 init
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Helm 3...........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Get HELM 3: https://github.com/helm/helm/releases
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh
rm -f ./get_helm.sh
sudo ln -s /usr/local/bin/helm /usr/local/bin/helm3
echo Installed "$(helm3 version)"
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing MiniKube.........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo "03-install-kube-dev-cli-tools.sh [helm] executed" >> "$HOME"/.packer.txt
echo
# Install Minikube
sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube
sudo chmod 755 /usr/local/bin/minikube
# Add minikube completions
# ZSH:
minikube completion zsh | sudo tee /usr/share/zsh/vendor-completions/_minikube &> /dev/null
# echo 'source <(minikube completion zsh)' | sudo tee -a /etc/zsh/zshrc
# echo 'source <(minikube completion bash)' | sudo tee -a /etc/bashrc
minikube completion bash | sudo tee /etc/bash_completion.d/minikube &> /dev/null
# Now show the version installed
minikube version
# minikube start
# minikube status
# minikube addons list
echo "03-install-kube-dev-cli-tools.sh [minikube] executed" >> "$HOME"/.packer.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing IstioCTL.........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
# Install istioctl: https://istio.io/docs/setup/getting-started/#download
# Start by parsing the current version:
#ISTIO_VERSION=$(curl -L -s https://api.github.com/repos/istio/istio/releases | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
# The following code is behind the above code!!?? NEED TO FIX
curl -L https://istio.io/downloadIstio | sh -
ISTIO_FOLDER=$(ls -al | grep istio | awk '{print $9}')
sudo chown root.root -R ./"$ISTIO_FOLDER"
sudo chmod 755 -R ./"$ISTIO_FOLDER"
if [ -d /usr/share/istio-* ]; then
  sudo rm -Rf /usr/share/istio-*
fi
sudo mv ./istio-* /usr/share
echo 'export PATH="$PATH:/usr/share/'"$ISTIO_FOLDER"'/bin"' | sudo tee -a /etc/zsh/zshenv
export PATH="$PATH:/usr/share/$ISTIO_FOLDER/bin"
echo "istioctl Version: $(istioctl version --remote=false)" >> "$HOME"/.packer.txt
echo "03-install-kube-dev-cli-tools.sh [istio] executed" >> "$HOME"/.packer.txt

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing krew.............................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# echo
KREW="krew-linux_amd64" &&
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && 
tar -zxvf ${KREW}* && 
./${KREW} install krew
export PATH="${PATH}:${HOME}/.krew/bin"
echo 'export PATH="${PATH}:${HOME}/.krew/bin"' >> .zshenv
rm -f ${KREW}* LICENSE
echo "03-install-kube-dev-cli-tools.sh [krew] executed" >> "$HOME"/.packer.txt

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing tilt.............................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
if [ ! -f /usr/local/bin/tilt ]; then
  curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | sudo bash 2>/dev/null 
  CTLPTL_FILE=$(curl -s https://api.github.com/repos/tilt-dev/ctlptl/releases/latest | grep browser_download_url | grep 'linux\.x86' | cut -d '"' -f 4)
  curl -fsSL "$CTLPTL_FILE" 2>/dev/null | sudo tar -xzv -C /usr/local/bin ctlptl 
  ctlptl version
fi
echo "03-install-kube-dev-cli-tools.sh [tilt] executed" >> "$HOME"/.packer.txt

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing MinIO Client.....................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
if [ ! -f /usr/local/bin/mc ]; then

sudo curl https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
sudo chmod +x /usr/local/bin/mc
fi
echo "03-install-kube-dev-cli-tools.sh [MinIO Client] executed" >> "$HOME"/.packer.txt

if [ ! -f /usr/local/bin/flux ]; then
  echo
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing flux        .....................#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  # Flux: https://fluxcd.io/flux/installation/
  curl -s https://fluxcd.io/install.sh | sudo bash
  echo 'source <(flux completion zsh)' | sudo tee -a /etc/zsh/zshrc
  echo 'source <(flux completion bash)' | sudo tee -a /etc/bashrc
  echo "03-install-kube-dev-cli-tools.sh [flux] executed" >> "$HOME"/.packer.txt
fi

if [ ! -f /usr/local/bin/velero ]; then
  echo
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing velero      .....................#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  velero_version=$(curl -L -s https://api.github.com/repos/vmware-tanzu/velero/releases/latest | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/")
  export velero_version
  curl -L https://github.com/vmware-tanzu/velero/releases/download/"$velero_version"/velero-"$velero_version"-linux-amd64.tar.gz -o velero-"$velero_version"-linux-amd64.tgz
  tar -zxvf velero-"$velero_version"-linux-amd64.tgz
  sudo cp velero-"$velero_version"-linux-amd64/velero /usr/local/bin
  rm -Rf velero-"$velero_version"-linux-amd64
  rm velero-"$velero_version"-linux-amd64.tgz
  # Now display version:
  velero version --client-only

  # Add velero bash completion:
  echo 'source <(velero completion bash)' | sudo tee -a /etc/bashrc
  velero completion bash | sudo tee /etc/bash_completion.d/velero

  # Add velero zsh completion:
  echo 'source <(velero completion zsh)' | sudo tee -a /etc/zsh/zshrc
  echo 'alias v=velero' | sudo tee -a /etc/zsh/zshrc
  echo 'complete -F __start_velero v' | sudo tee -a /etc/zsh/zshrc
  echo "03-install-kube-dev-cli-tools.sh [velero] executed" >> "$HOME"/.packer.txt
fi
