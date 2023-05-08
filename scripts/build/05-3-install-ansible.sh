#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# If sudo is required in the rest of the script, check for it first
# and exit with non-zero if not sudo:
if sudo -l | grep -q -c apt ; then
  echo "Installing Ansible" > ~/.status.txt
  echo
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  /bin/echo -e "\e[38;5;39m# Installing Ansible..........................#\e[0m"
  /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
  echo
  # Install ansible
  sudo pip3 install --root / ansible
  sudo pip3 install --root / argcomplete

  # Add auto-complete to zsh: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#adding-ansible-command-shell-completion
  # TODO: Need to follow up on this
  #  echo 'eval $(register-python-argcomplete3 ansible)\n'      \
  # 'eval $(register-python-argcomplete3 ansible-config)\n'    \
  # 'eval $(register-python-argcomplete3 ansible-console)\n'   \
  # 'eval $(register-python-argcomplete3 ansible-doc)\n'       \
  # 'eval $(register-python-argcomplete3 ansible-galaxy)\n'    \
  # 'eval $(register-python-argcomplete3 ansible-inventory)\n' \
  # 'eval $(register-python-argcomplete3 ansible-playbook)\n'  \
  # 'eval $(register-python-argcomplete3 ansible-pull)\n'      \
  # 'eval $(register-python-argcomplete3 ansible-vault)\n'     >> ~/.zshenv

  ansible --version
  # Install awx cli as per: https://github.com/ansible/awx/blob/devel/INSTALL.md
  sudo pip3 install --root / awxkit
  awx --version

else
  exit 1
fi
echo "05-3-install-ansible.sh executed" >> "$HOME"/.packer.txt
