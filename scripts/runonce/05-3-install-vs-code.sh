#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

    # Please define your extensions here. One per line, enclosed in quotes. NO COMMAS
    vscode_extensions=(
        "anseki.vscode-color"
        "dandric.vscode-jq" 
        "eamodio.gitlens" 
        "ffaraone.opensslutils"
        "formulahendry.code-runner" 
        "Gruntfuggly.todo-tree"
        "hangxingliu.vscode-systemd-support"
        "HashiCorp.terraform"
        "HashiCorp.HCL"
        "jeremyrajan.file-script-runner"
        "mohsen1.prettify-json"  
        "ms-azuretools.vscode-docker" 
        "ms-kubernetes-tools.vscode-kubernetes-tools" 
        "ms-python.python"         
        "ms-vscode.powershell"
        "nico-castell.linux-desktop-file"
        "redhat.ansible"
        "redhat.vscode-yaml" 
        "richie5um2.vscode-statusbar-json-path" 
        "timonwong.shellcheck"
        "vscjava.vscode-java-pack" 
        "vscode-icons-team.vscode-icons" 
        "vangware.dark-plus-material" 
        "wayou.vscode-todo-highlight"
        "xcad2k.vscode-thedigitallife"
        "zainchen.json" )
    echo "Installing VS Code" > ~/.status.txt
    # Reference: https://code.visualstudio.com/docs/setup/linux
    echo
    /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
    /bin/echo -e "\e[38;5;39m# Installing Visual Studio Code ..............#\e[0m"
    /bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
    echo
    if [ ! -f /usr/share/keyrings/microsoft-prod.gpg ]; then
        sudo apt install -y wget gpg apt-transport-https
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft-prod.gpg
        sudo install -o root -g root -m 644 microsoft-prod.gpg /usr/share/keyrings/
        rm -f microsoft-prod.gpg
    fi
    if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    fi
    # Manual scripting... yuck
    # UBUNTU_VERSION_ID=$(cat /etc/os-release | grep ^VERSION_ID= | cut -d'=' -f2 | sed -e 's/^"//' -e 's/"$//')
    # wget -q https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION_ID}/packages-microsoft-prod.deb
    # sudo dpkg -i packages-microsoft-prod.deb
    # rm -f packages-microsoft-prod.deb
    # snap store - meh
    # snap install code
    sudo apt update
    sudo apt install -y code

    echo
    /bin/echo -e "\e[38;5;39m#===============================================================#\e[0m"
    /bin/echo -e "\e[38;5;39m# Moving VS Code extensions to /usr/local/share/code-extensions #\e[0m"
    /bin/echo -e "\e[38;5;39m#===============================================================#\e[0m"
    echo
    echo "Moving Extensions to  /usr/local/share/code-extensions" > ~/.status.txt
    # Configure Code to use a shared folder for extensions storage:
    # This folder can grow over 1GB, resulting in long first-login times
    # for new user where /etc/skel must be copied.. so instead store in shared location
    # and configure code launcher to use alternate folder:
    sudo mkdir -p /usr/local/share/code-extensions
    # The next line is only valid if you had installed extensions before moving to shared location
    # sudo mv ~/.vscode/extensions/* /usr/local/share/code-extensions
    sudo chmod 777 -R /usr/local/share/code-extensions

    # Now add alias for code to specify the extensions dir:
    echo 'alias code="code --extensions-dir /usr/local/share/code-extensions"' | sudo tee -a /etc/zsh/zshrc
    # And update the icon in Gnome:
    sudo sed -i 's/Exec=\/usr\/share\/code\/code/& --extensions-dir \/usr\/local\/share\/code-extensions/g' /usr/share/applications/code.desktop
    # Now copy to $HOME and skel:
    mkdir -p ~/.local/share/applications
    sudo mkdir -p /etc/skel/.local/share/applications
    sudo cp /usr/share/applications/code.desktop ~/.local/share/applications
    sudo cp /usr/share/applications/code.desktop /etc/skel/.local/share/applications
    sudo chown "${USER}"."${USER}" ~/.local/share/applications/*.*
    echo "Installing Code Extensions" > ~/.status.txt
    for vs_ext in "${vscode_extensions[@]}"; do
      echo Installing extension: "$(echo "$vs_ext" | cut -d'.' -f2;)" > ~/.status.txt
      code --no-sandbox --force --user-data-dir "$HOME" --extensions-dir /usr/local/share/code-extensions --log off --install-extension "$vs_ext"
    done

    echo "Adjust VS Code settings" > ~/.status.txt
    mkdir -p ~/.config/Code/User
cat > ~/.config/Code/User/settings.json << "EOF"
    {
    "workbench.iconTheme": "vscode-icons",
    "workbench.colorTheme": "Dark+ Material",
    "editor.fontFamily": "'MesloLGS NF','Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
    "editor.minimap.enabled": false,
    "redhat.telemetry.enabled": false,
    "vs-kubernetes": {
        "vscode-kubernetes.minikube-path.linux": "/usr/local/bin/minikube",
        "vscode-kubernetes.helm-path": "/usr/local/bin/helm",
        "vscode-kubernetes.kubectl-path.linux": "/usr/local/bin/kubectl"
    },
    "security.workspace.trust.untrustedFiles": "open",
    "git.enableSmartCommit": true,
    "git.autofetch": true,
    "git.confirmSync": false,
    "files.autoSave": "afterDelay",
    "explorer.confirmDragAndDrop": false,
    "java.server.launchMode": "Standard",
    "bracket-pair-colorizer-2.depreciation-notice": false,
    "java.help.showReleaseNotes": false,
    "maven.terminal.useJavaHome": true,
    "todo-tree.general.tags": [
        "BUG",
        "HACK",
        "FIXME",
        "TODO",
        "XXX",
        "[ ]",
        "[x]"
    ],
    "todo-tree.regex.regex": "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)",
    
    "[powershell]": {
        "debug.saveBeforeStart": "nonUntitledEditorsInActiveGroup",
        "editor.semanticHighlighting.enabled": true,
        "editor.wordSeparators": "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?"
    },
    "vsicons.dontShowNewVersionMessage": true,
    "shellcheck.exclude": [
      "2016",
      "2144",
      "2129"
    ],
    "terminal.integrated.fontSize": 12,
    "opensslutils.opensslPath": "/usr/bin/openssl",
    "gitlens.showWhatsNewAfterUpgrades": false,
    "gitlens.showWelcomeOnInstall": false,
    "java.jdt.ls.java.home": "/usr/lib/jvm/java-8-openjdk-amd64"
    }
EOF

# Some of the regex/word separators in the above json cause error with jq so cannot use the code below
# Load the current Visual Studio Code Settings:
# VSCODE_SETTINGS=$(cat "$HOME"/.config/Code/User/settings.json)
# Make additions as needed:
# VSCODE_SETTINGS=$(echo "$VSCODE_SETTINGS" | jq  '. += {"java.jdt.ls.java.home": "/usr/lib/jvm/java-8-openjdk-amd64"}')

# Once all additions are needed, overwrite/update the settings.json file
# echo "$VSCODE_SETTINGS" > "$HOME"/.config/Code/User/settings.json
