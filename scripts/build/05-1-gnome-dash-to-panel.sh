#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
# no sudo needed
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Initializing Gnome Extensions dash-to-panel #\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
#!/bin/bash
#-- Create Temporary Folder ------------------------------------
declare folder_name="$RANDOM-dash-to-panel";
declare folder_path="/tmp/$folder_name"

mkdir "$folder_path";
cd "$folder_path";

#-- Download Source Code ------------------------------------
sudo apt install git -y;
git clone "https://github.com/home-sweet-gnome/dash-to-panel.git";
cd "dash-to-panel/";

#-- Install Dependencies  ------------------------------------
sudo apt install gettext -y;
sudo apt install make -y;

#-- Install Extension ------------------------------------
make install;
gnome-extensions enable "dash-to-panel@jderose9.github.com";
#--- Install the Schema so that gsettings knows about it
SCHEMADIR="$HOME/.local/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas"
# Add the dash-to-panel schema to the system
sudo cp "$SCHEMADIR"/org.gnome.shell.extensions.dash-to-panel.gschema.xml /usr/share/glib-2.0/schemas
# NOW RE-COMPILE THE SCHEMA
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
if [ -f "$HOME/Pictures/Logo.png" ]; then
  sudo cp -f "$HOME"/Pictures/Logo.png /usr/share/icons/my-logo.png
  sudo chmod 644 /usr/share/icons/my-logo.png
fi
#-- Remove Temporary Folder ------------------------------------
rm -rf "$folder_path";
echo "05-1-install-gnome-dash-to-panel.sh executed" >> "$HOME"/.packer.txt