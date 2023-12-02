# Copy the PowerShell setting files to the correct locations

# Copy the profiles
Copy-Item -Path "$PSScriptRoot\*.ps1" -Destination "$env:USERPROFILE\Documents\PowerShell\" -Force

# Copy the themes
Copy-Item -Path "$PSScriptRoot\themes\*.json" -Destination "$env:POSH_THEMES_PATH\" -Force

# Reload the profile
. $PROFILE