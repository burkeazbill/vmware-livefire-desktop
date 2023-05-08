#!/usr/bin/bash -e
#
echo
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
/bin/echo -e "\e[38;5;39m# Installing PowerCLI.........................#\e[0m"
/bin/echo -e "\e[38;5;39m#=============================================#\e[0m"
echo
if ! command -v pwsh &> /dev/null
then
    echo "Unable to install PowerCLI since PowerShell does not appear to be installed - unable to execute pwsh" >> "$HOME"/.packer.txt
else
# Install PowerCLI: must be done manually...
cat > /tmp/install-powercli.ps1 << "EOF"
# Trust the PSGallery:
$ErrorActionPreference = "SilentlyContinue"
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name VMware.PowerCLI
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
EOF
  pwsh /tmp/install-powercli.ps1
  sudo pwsh -c '$ErrorActionPreference = "SilentlyContinue"; Import-Module -Name VMware.PowerCLI; Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP $false -Confirm:$false'
  rm /tmp/install-powercli.ps1
  # If the link is left in the user directory, it will result in Modules showing twice
  unlink "$HOME/.local/share/powershell"
  echo PowerCLI Version: \""$(pwsh -c 'Get-Module -ListAvailable VMware.PowerCLI | Select-Object -Property Version | Format-Table -HideTableHeaders' | xargs)"\" >> "$HOME"/.packer.txt
fi