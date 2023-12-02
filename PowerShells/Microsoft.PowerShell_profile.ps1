# Oh-My-Posh:
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\my-theme.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\zash.omp.json" | Invoke-Expression

Import-Module Get-ChildItemColor
If (-Not (Test-Path Variable:PSise)) {
    # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor   
    Set-Alias l Get-ChildItemColor -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope 
}

# Virtual Environment
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Load aliases from another ps1 file
. "$PSScriptRoot\Unix.Aliases_profile.ps1"
. "$PSScriptRoot\My.Aliases_profile.ps1"
