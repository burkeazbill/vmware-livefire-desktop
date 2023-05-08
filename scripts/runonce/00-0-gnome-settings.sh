#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Initializing Custom Gnome Desktop Settings  #\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo

echo "Adjusting Gnome" > ~/.status.txt
# Add gnome-clocks world-clocks: Austin, London, Singapore:
gsettings set org.gnome.clocks world-clocks "[{'location': <(uint32 2, <('Austin', 'KAUM', true, [(0.76212711252195475, -1.6219926457022995)], [(0.7621264667501314, -1.6227135364965433)])>)>}, {'location': <(uint32 2, <('London', 'EGWU', true, [(0.89971722940307675, -0.007272211034407213)], [(0.89884456477707964, -0.0020362232784242244)])>)>}, {'location': <(uint32 2, <('Singapore', 'WSAP', true, [(0.023852838928353343, 1.8136879868485383)], [(0.022568084612667797, 1.8126262332513803)])>)>}]"

# Adjust Gnome Desktop: (To see/browse possible settings, use dconf-editor GUI tool in Gnome)
gsettings set org.gnome.desktop.background picture-uri ""
gsettings set org.gnome.desktop.background primary-color '#234f79'
gsettings set org.gnome.desktop.background show-desktop-icons false
# The default icon theme has no color, switch to another built-in theme: Yaru-blue
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
# Fix the Window Title-bar so that it includes minimize, maximize, and close on the right
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
# Disable Screensaver and Idle Lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.desktop.session idle-delay 0
# Reduce file manager icon size from large to small:
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.list-view use-tree-view true

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

gsettings set org.gtk.settings.file-chooser sort-directories-first true
gsettings set org.gtk.gtk4.settings.file-chooser sort-directories-first true

# Configure the Dock, starting with Dock icons:
gsettings set org.gnome.shell favorite-apps "['microsoft-edge.desktop', 'google-chrome.desktop', 'brave-browser.desktop', 'code.desktop', 'terminator.desktop', 'org.gnome.Terminal.desktop', 'powershell_powershell.desktop', 'drawio.desktop', 'postman_postman.desktop', 'org.remmina.Remmina.desktop', 'shutter.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'slack.desktop']"
# The dash-to-dock settings here are commented out because we switch to dash-to-panel
gsettings set org.gnome.shell enabled-extensions "['ubuntu-dock@ubuntu.com', 'ubuntu-appindicators@ubuntu.com']"
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock autohide 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock cycle-windows 'focus-minimize-or-preview'
gsettings set org.gnome.shell.extensions.dash-to-dock disable-overview-on-startup 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock animate-show-apps 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '25'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height 'true'
sleep 3

######## Terminator Custom Config Setup #######
echo "Configuring Terminator" > ~/.status.txt
mkdir -p ~/.config/terminator
mv ~/.scripts/runonce/terminator.conf ~/.config/terminator/config

# Build exported terminal settings
# File generated with this command: dconf dump /org/gnome/terminal/ > ~/.gnome_terminal_settings_backup
# This is a customized Tango Dark theme:
echo "Configuring Gnome Terminal" > ~/.status.txt
cat > ~/.gnome_terminal_settings_backup << "EOF"
[legacy]
schema-version=uint32 3

[legacy/keybindings]
copy='<Primary>c'
paste='<Primary>v'
select-all='<Primary>a'

[legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
background-color='rgb(0,0,0)'
background-transparency-percent=2
bold-is-bright=false
default-size-columns=95
font='MesloLGS NF 12'
foreground-color='rgb(255,255,255)'
login-shell=false
palette=['rgb(46,52,54)', 'rgb(204,0,0)', 'rgb(78,154,6)', 'rgb(196,160,0)', 'rgb(52,101,164)', 'rgb(117,80,123)', 'rgb(6,152,154)', 'rgb(211,215,207)', 'rgb(85,87,83)', 'rgb(239,41,41)', 'rgb(138,226,52)', 'rgb(252,233,79)', 'rgb(114,159,207)', 'rgb(173,127,168)', 'rgb(52,226,226)', 'rgb(238,238,236)']
scroll-on-output=true
scrollback-lines=20000
scrollback-unlimited=true
use-custom-command=false
use-system-font=false
use-theme-colors=false
use-theme-transparency=false
use-transparent-background=false
visible-name='White-Black-Tango'
EOF

# Now import gnome terminal settings that were exported:
chmod +x "$HOME/.scripts/runonce/term-settings.sh"

if [ -f "$HOME/.scripts/runonce/term-settings.sh" ]; then bash -c "$HOME/.scripts/runonce/term-settings.sh; mv $HOME/.scripts/runonce/ran/term-settings.sh"; fi
exit 0