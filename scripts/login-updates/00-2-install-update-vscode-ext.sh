#!/bin/bash
# Purpose: allow for easy VSCode extension install and update from network share
# Instructions: Create network share path that is available to users upon login
#   - Make sure that login process calls this script
#   - Update SOURCE_PATH line to reflect path to folder containing .vsix file(s)

# Define Network Source path for .vsix folder
SOURCE_PATH="$HOME/attendee-share/.admin/vscode"
STATUS_FILE="$HOME/.status.txt"
export login_script_log="$HOME/.login.txt"

echo "[00-2-install-update-vscode-ext.sh] - Starting" | tee -a "$login_script_log" > .status.txt
################## Added March 2022 #######################
echo "Upgrading code if update available..." > .status.txt
sudo apt install -y --only-upgrade code

# Don't bother with this script if code is not even installed:
if [ ! -f "/usr/bin/code" ]; then
  echo "ERROR! Code is not installed! install-update-vscode-ext script exiting." 2>&1 | tee -a "$login_script_log"
  exit;
fi

# Determine whether or not Burke's Script has been used and the shared code-extensions folder is created:
if [ -d "/usr/local/share/code-extensions" ]; then
  # This is the shared folder location that Burke's scripts configure VS Code to use
  EXTENSION_DIR="/usr/local/share/code-extensions"
else
  # This is the default Visual Studio Cde Extension Folder
  EXTENSION_DIR="$HOME/.vscode/extensions/"
fi
# Create a list of extensions already on desktop
echo "EXTENSION_DIR: ${EXTENSION_DIR}"
echo "" > /tmp/installed-extensions.txt
# The following for loop will generate output that matches the output of : code --list-extensions --show-versions
# The loop is required becase the code command does not generate output when used in a script
for EXT_DIR in "${EXTENSION_DIR}"/*
do
    if [ ! -f "$EXT_DIR/package.json" ]; then
    continue
    else
    jq -r '[.publisher,.name,.version] | "\(.[0]).\(.[1])@\(.[2])"' "$EXT_DIR/package.json" 2>&1 | tee -a /tmp/installed-extensions.txt
    fi
done
echo "=================================================================="
echo "$(wc -l < /tmp/installed-extensions.txt)" Extensions found!

# Only continue processing if the SOURCE_PATH is accessible
if [ -d "${SOURCE_PATH}" ]; then
  echo "VS Code Extensions Path found, installing..."
  EXT_COUNT=$(find "${SOURCE_PATH}"/*.vsix | wc -l)

  echo "Processing VS Code extensions" > "${STATUS_FILE}"
  if [ ${EXT_COUNT} -gt 0 ]; then
    # Set variable for temporary extenstion extraction:
    EXTRACT_FOLDER_TEST="/tmp/code-EXTENSION-test"
    echo "=================================================================="
    for EXTENSION_FILE in "${SOURCE_PATH}"/*.vsix
    do
      if [ ! -f "$EXTENSION_FILE" ]; then
        continue
      else
        echo "Processing -> $EXTENSION_FILE"
        mkdir -p "$EXTRACT_FOLDER_TEST"
        # Extract extension to temp folder:
        unzip "$EXTENSION_FILE" -d "$EXTRACT_FOLDER_TEST" >/dev/null
        # Get Extension Publisher
        EXTENSION_PUBLISHER=$(jq ".publisher" "$EXTRACT_FOLDER_TEST"/extension/package.json | xargs)
        # Get Extension Name
        EXTENSION_NAME=$(jq ".name" "$EXTRACT_FOLDER_TEST"/extension/package.json | xargs)
        # Get Extension Version
        EXTENSION_FILE_VERSION=$(jq ".version" "$EXTRACT_FOLDER_TEST"/extension/package.json | xargs)
        #EXTENSION_FILE_VERSION=$(cat "$EXTRACT_FOLDER_TEST"/extension.vsixmanifest| grep Identity | cut -d"=" -f 4 | cut -d" " -f 1 |  sed -e 's/^"//' -e 's/"$//')
        EXTENSION_FILENAME=$(basename "$EXTENSION_FILE")
        # Initialize flag:
        INSTALL_EXTENSION="false"
        INSTALLED_EXTENSION_VERSION=""
        # Cleanup temp
        sudo rm -Rf "$EXTRACT_FOLDER_TEST"
        DEST_FOLDER_NAME="${EXTENSION_PUBLISHER,,}.${EXTENSION_NAME}.${EXTENSION_FILE_VERSION}"
        echo "${EXTENSION_FILENAME} : ${DEST_FOLDER_NAME}"

        # Check if installed:
        if grep -Fq "$EXTENSION_PUBLISHER.$EXTENSION_NAME@" /tmp/installed-extensions.txt; then
            # If installed, get installled version
            INSTALLED_EXTENSION_VERSION=$(grep -F "$EXTENSION_PUBLISHER.$EXTENSION_NAME@" /tmp/installed-extensions.txt | cut -d"@" -f2)
            # INSTALLED_EXTENSION_VERSION=$(cat "$EXTENSION_DIR"/"$EXTENSION_NAME"-*/package.json | jq ".version" | tail -n 1 | sed -e 's/^"//' -e 's/"$//')
            echo "$EXTENSION_NAME version $INSTALLED_EXTENSION_VERSION is currently installed" 2>&1 | tee -a "$login_script_log"
        else
            # If not installed, set Install flag to yes
            echo "$EXTENSION_NAME is not currently installed" 2>&1 | tee -a "$login_script_log"
            INSTALL_EXTENSION="true"
        fi

        if [ "$INSTALLED_EXTENSION_VERSION" ]; then
            echo "$EXTENSION_NAME version $EXTENSION_FILE_VERSION is now available" 2>&1 | tee -a "$login_script_log"
            # If version is not the same set Install flag to yes
            if [ "$EXTENSION_FILE_VERSION" == "$INSTALLED_EXTENSION_VERSION" ]; then
            echo "Installed and available versions are the same, no action required..." 2>&1 | tee -a "$login_script_log"
            else
            echo "Installed version $INSTALLED_EXTENSION_VERSION is not the same as the File version $EXTENSION_FILE_VERSION, installing File..." 2>&1 | tee -a "$login_script_log"
            # Uninstall the existing EXTENSION to prevent buildup of extra versions:
            code --uninstall-extension "$EXTENSION_NAME" 2>/dev/null
            sudo rm -Rf "$EXTENSION_DIR"/"$EXTENSION_NAME"-"$INSTALLED_EXTENSION_VERSION"
            INSTALL_EXTENSION="true"
            fi
        fi

        # Check Install flag, if yes run installer:
        if [ "$INSTALL_EXTENSION" == "true" ]; then
            echo "Installing VSCode Ext: $EXTENSION_NAME" 2>&1 | tee -a "$login_script_log" >  "${STATUS_FILE}"
            echo "Running command: code --extensions-dir $EXTENSION_DIR --log off --install-extension $EXTENSION_FILE 2>/dev/null" 2>&1 | tee -a "$login_script_log"
            code --no-sandbox --force --extensions-dir "$EXTENSION_DIR" --log off --install-extension "$EXTENSION_FILE" 2>/dev/null
        else
            echo "$EXTENSION_NAME is already installed." 2>&1 | tee -a "$login_script_log"
        fi
        # Cleanup:
        # rm -Rf "$EXTRACT_FOLDER_TEST"
        # rm /tmp/installed-extensions.txt
      fi
      echo "=================================================================="
    done
  else
    echo "No .vsix files found!!"
  fi
fi
echo "[00-2-install-update-vscode-ext.sh] - Complete" | tee -a "$login_script_log" > "${STATUS_FILE}"