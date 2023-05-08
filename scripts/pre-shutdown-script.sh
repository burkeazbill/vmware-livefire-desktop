#!/bin/bash
#
# Author: Burke Azbill
# Purpose: Provide a means to run scripts at shutdown and/or reboot
# 
# Overview: This script will be called by a custom service: pre-shutdown.service
# Service must be enabled in order for the script to run at shutdown/reboot

# Placeholder script to show it runs (can remove upon implementation of custom scripts)
# Since the service runs as root, the txt file will be placed in /root
echo "pre-shutdown script ran!" > ~/.pre-shutdown-ran.txt

# Do something more interesting here:
