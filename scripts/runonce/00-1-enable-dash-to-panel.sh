#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Enabling dash-to-panel" > ~/.status.txt
# no sudo needed
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Enabling Gnome Extensions dash-to-panel.... #\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
ext_name="dash-to-panel@jderose9.github.com"
echo "=============================================" >> "$HOME"/.scripts/runonce/.lastrun.log
#-- Confirm extension is installed-----------------------
if gnome-extensions list | grep -q $ext_name; then
  echo "=> $ext_name is installed." >> "$HOME"/.scripts/runonce/.lastrun.log
  if gnome-extensions show $ext_name | grep -q ENABLED; then 
    echo "=> $ext_name is already enabled." >> "$HOME"/.scripts/runonce/.lastrun.log
  else
    #-- Enable Extension ------------------------------------
    echo "=> $ext_name is installed, enabling..." >> "$HOME"/.scripts/runonce/.lastrun.log
    gnome-extensions enable $ext_name;
    #-- Set preferences:
    # An alternate method would be to use the dash-to-panel properties to set all preference, then dump the settings:
    # dconf dump /org/gnome/shell/extensions/ > ~/gnome_extensions_settings_backup.txt
    # Then, load the setting here like this:
    # dconf load /org/gnome/shell/extensions/ < ~/gnome_extensions_settings_backup.txt
    #
    # Here's the cli method of doing it (NOTE: schema must be added already!)
    gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":32}'
    gsettings set org.gnome.shell.extensions.dash-to-panel desktop-line-custom-color 'rgb(98,160,234)'
    gsettings set org.gnome.shell.extensions.dash-to-panel showdesktop-button-width '20'
    gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin '4'
    gsettings set org.gnome.shell.extensions.dash-to-panel appicon-padding '2'
    gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-unfocused 'DASHES'
    gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
    gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity '0.3'
    gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-opacity true
    gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover true
    gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-extent "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}"
    gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-travel "{'SIMPLE': 0.3, 'RIPPLE': 0.4, 'PLANK': 0.5}"
    gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-zoom "{'SIMPLE': 1.75, 'RIPPLE': 1.75, 'PLANK': 2.0}"
    gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-duration "{'SIMPLE': 50, 'RIPPLE': 130, 'PLANK': 50}"
    gsettings set org.gnome.shell.extensions.dash-to-panel hide-overview-on-startup true
    if [ -f /usr/share/icons/my-logo.png ]; then
      gsettings set org.gnome.shell.extensions.dash-to-panel show-apps-icon-file "/usr/share/icons/my-logo.png"
    else
      gsettings set org.gnome.shell.extensions.dash-to-panel show-apps-icon-file '/usr/share/icons/gnome-logo-text-dark.svg'
    fi
    sleep 5
    busctl --user call "org.gnome.Shell" "/org/gnome/Shell" "org.gnome.Shell" "Eval" "s" 'Meta.restart("Restarting…")';
  fi
else
  #--------------------------------------
  echo "=> $ext_name is not installed." >> "$HOME"/.scripts/runonce/.lastrun.log
fi
