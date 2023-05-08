#!/bin/bash
# File location: /usr/local/bin
# Purpose: Refresh the apt cache and run the scripts that should be executed after Gnome has loaded.
export DEBIAN_FRONTEND=noninteractive
# Avoid checking pat cache if the pkgcache doesn't exist:
# If the apt cache is older than 60 minutes, perform an update
# This allows for apt installs in later login scripts and .desktop launched apt installs if/when needed
if [ -z "$(find /var/cache/apt/pkgcache.bin -mmin -60 2>/dev/null)" ]; then
  echo "Refreshing apt cache" > ~/.status.txt
  sudo apt update 2>/dev/null
fi
runonce_log="$HOME/.scripts/runonce/.runonce.log"
# Only attempt to run this command if the runonce folder exists:
if [ -d "$HOME/.scripts/runonce" ]; then
  script_count=$(find "$HOME/.scripts/runonce" | wc -l)

  echo "Processing ${script_count} runonce scripts" > ~/.status.txt
  if [ ${script_count} -gt 2 ]; then
    date +%Y-%m-%d-%H:%M:%S >> "$runonce_log"
    echo "=============================================" >> "$runonce_log"
    echo "Processing runonce scripts" >> "$runonce_log"
    for file in "$HOME"/.scripts/runonce/*sh
    do
      if [ ! -f "$file" ]; then
        continue
      else
        bash "$file"
        if [ $? -eq 0 ]; then
          echo "Moving $file --> $HOME/.scripts/runonce/ran/$(basename "$file")" >> "$runonce_log"
          mv "$file" "$HOME/.scripts/runonce/ran/$(basename "$file")"
        else
          echo "Failed to run $file - check sudo access!" >> "$runonce_log"
        fi
      fi
    done
  fi
fi
# Only attempt to run this command if the login-updates folder exists:
if [ -d "$HOME/.scripts/login-updates" ]; then
  login_updates_log="$HOME/.scripts/login-updates/.login-updates.log"
  # Make sure all *sh files are marked executable, otherwise run-parts will ignore them!
  chmod -f +x "$HOME"/.scripts/login-updates/*sh
  # Keep track of the lat time the scripts actually processed:
  date > "$login_updates_log"
  echo "Processing Login Updates" > ~/.status.txt
  echo "Processing the following scripts:" >> "$login_updates_log"
  # The sole purpose of this test line is to generate output to the log file:
  run-parts --exit-on-error --list --regex '.*sh$' "$HOME/.scripts/login-updates" >> "$login_updates_log"
  # Now actually run the scripts:
  run-parts --exit-on-error --regex '.*sh$' "$HOME/.scripts/login-updates"
fi

# Cleanup any archive apt repos that were auto-created:
sudo rm -f /etc/apt/sources.list.d/archive_*
# Will now check if netlogon folder is available, and to run scripts if any found:
[ -f "/mnt/netlogon/login.sh" ] && bash /mnt/netlogon/login.sh

# Set Ready
echo "Ready" > ~/.status.txt