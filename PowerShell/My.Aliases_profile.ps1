# Shortcuts
function goToProjects {
    Set-Location F:\Projects
}
Set-Alias pro goToProjects

# * cd 
function cdPrev1 { Set-Location .. }
function cdPrev2 { Set-Location ..\.. }
function cdPrev3 { Set-Location ..\..\.. }
function cdPrev4 { Set-Location ..\..\..\.. }

Set-Alias .. cdPrev1
Set-Alias ... cdPrev2
Set-Alias .... cdPrev3
Set-Alias ..... cdPrev4

# * Systems
function reloadProfile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Running $_"
            . $_
        }
    }    
}

Set-Alias rl reloadProfile

# * Git
function gitStatus { git status }
function gitFetch { git fetch }
function gitAdd { git add }
function gitAddAll { git add --all }
function gitCommit { git commit }
function gitCommitMessage {
    git commit -m $args[0]
}
function gitPushOriginMain { git push origin main }
function gitPullOriginMain { git pull origin main }
function gitLog { git log }
function gitLogGraph { git log graph }

Set-Alias g git
Set-Alias gs gitStatus
Set-Alias gf gitFetch
Set-Alias ga gitAdd
Set-Alias gaa gitAddAll
Set-Alias gcmit gitCommit
Set-Alias gcmsg gitCommitMessage
Set-Alias gpom gitPushOriginMain
Set-Alias gpl gitPullOriginMain
Set-Alias glog gitLog
Set-Alias glg gitLogGraph

# * Python & Conda
function condaActivate { conda activate }
function condaDeactivate { conda deactivate }
function condaInfoEnvs { conda info --envs }

Set-Alias py python
Set-Alias conact condaActivate
Set-Alias conde condaDeactivate
Set-Alias conin condaInfoEnvs

# ? For my own reference:
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.4