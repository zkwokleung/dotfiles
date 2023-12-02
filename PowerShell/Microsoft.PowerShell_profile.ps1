# Auto Completes
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History

# Oh-My-Posh:
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\my-theme.json" | Invoke-Expression

# Import Modules
Import-Module Get-ChildItemColor
Import-Module -Name Terminal-Icons

# Virtual Environment
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Load aliases from another ps1 file
. "$PSScriptRoot\Unix.Aliases_profile.ps1"
. "$PSScriptRoot\My.Aliases_profile.ps1"
