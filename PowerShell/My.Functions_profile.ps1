# Shortcuts
function p {
    Set-Location F:\Projects
}

# * cd
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }

# * Systems
function rl {
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

# * Git
function gs { git status }
function gf { git fetch }
function ga { git add }
function gaa { git add --all }
function gcmit { git commit }
function gcmm {
    git commit -m $args[0]
}
function gpom { git push origin main }
function glom { git pull origin main }
function glog { git log }
function glg { git log graph }

# * Python & Conda
function conact { conda activate }
function conde { conda deactivate }
function conin { conda info --envs }

# ? For my own reference:
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.4