# Creat Unix style aliases
Set-Alias alias Set-Alias

Set-Alias which Get-Command
Set-Alias open Invoke-Item

Set-Alias l Get-ChildItem -option AllScope
Set-Alias ls Get-ChildItem -option AllScope
Set-Alias la Get-ChildItem -Force

Set-Alias clip Set-Clipboard
Set-Alias pbcopy Set-Clipboard

Set-Alias ps Get-Process
Set-Alias kill Stop-Process

Set-Alias clear Clear-History

Set-Alias h Get-History

Set-Alias df Get-DiskFreeSpace
Set-Alias du Get-DirectorySize

Set-Alias vi vim
Set-Alias nano notepad

Set-Alias top Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

Set-Alias grep Select-String

Set-Alias wget Invoke-WebRequest
Set-Alias curl Invoke-WebRequest