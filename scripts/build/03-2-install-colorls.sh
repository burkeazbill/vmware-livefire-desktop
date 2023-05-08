#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

### colorls
sudo apt install -yy ruby ruby-dev gcc make
sudo gem install colorls
COLORLSDIR=$(dirname "$(gem which colorls)")
source "$COLORLSDIR"/tab_complete.sh
echo "source $COLORLSDIR/tab_complete.sh"  | sudo tee -a /etc/zsh/zshrc
echo 'alias ls="colorls --sd"' | sudo tee -a /etc/zsh/zshrc
echo 'alias ls="colorls --sd"' >> ~/.zshrc
echo 'if ! command -v tree &> /dev/null' | sudo tee -a /etc/zsh/zshrc
echo 'then' | sudo tee -a /etc/zsh/zshrc
echo '  alias tree="ls --tree"' | sudo tee -a /etc/zsh/zshrc
echo 'fi' | sudo tee -a /etc/zsh/zshrc

echo "source $COLORLSDIR/tab_complete.sh"  | sudo tee -a /etc/bashrc
echo 'alias ls="colorls --sd"' | sudo tee -a /etc/bash.bashrc
echo 'alias ls="colorls --sd"' >> ~/.bashrc
echo "03-install-colorls.sh executed" >> "$HOME"/.packer.txt