#!/bin/bash
# IMPORTANT - dconf requires the leading and trailing slash
# File generated with this command: dconf dump /org/gnome/terminal/ > ~/.gnome_terminal_settings_backup
# cat ~/.gnome_terminal_settings_backup | dconf load /org/gnome/terminal/
dconf load /org/gnome/terminal/ < ~/.gnome_terminal_settings_backup
# if [ -f "$HOME/.gnome_terminal_settings_backup" ]; then
#   rm -f "$HOME"/.gnome_terminal_settings_backup
# fi