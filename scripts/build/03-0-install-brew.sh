#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
login_script_log=$HOME/.login.txt

echo "Installing Homebrew (brew)" > ~/.status.txt
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing Brew.............................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

if ! command -v brew &> /dev/null
then
  echo "brew not found, installing now..." >> "$login_script_log"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshenv
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  sudo groupadd brew
  sudo usermod -aG brew ${USER}
  sudo chown root.brew -R /home/linuxbrew
  #TODO Auto completion causing issues.. needs further research
  #sudo chmod -R go-w /home/linuxbrew/.linuxbrew/share
  
  # Autocompletion: https://docs.brew.sh/Shell-Completion
  #  echo -e '\nif type brew &>/dev/null\n'\
  #  'then\n'\
  #    'FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"\n'\
  #    'autoload -Uz compinit\n'\
  #    'compinit\n'\
  #  'fi\n' >> ~/.zshenv
else
  echo "brew is already installed" >> "$login_script_log"
fi

echo "05-3-install-brew.sh executed" >> "$HOME"/.packer.txt