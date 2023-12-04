# zkwokleung's dotfiles

## Introduction
The dotfiles are based on [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) with my own personal changes. Since I am a MacOS and Windows user, this repository might not work properly on Linux enviroments.

**Warning:** This is a very personal repository and it may not fits your daily workflow. You can take it as a reference for creating your own dotfiles project.

## Features
### MacOS & Unix
- Automatically enter tmux
- Better looking ls

### PowerShell
- Unix-like command aliases
- Nice looking terminal

## Installation
### MacOS & Unix
```bash
./bootstrap.sh
```
### PowerShell
```bash
cd PowerShell && ./bootstrap.ps1
```

## Dependencies
### MacOS & Unix
- [tmux](https://github.com/tmux/tmux/wiki) with [Oh-my-tmux!](https://github.com/gpakosz/.tmux) - VERY USEFUL
- [exa](https://github.com/ogham/exa) - Better ls
- [pnpm](https://github.com/pnpm/pnpm) - Better npm
- [NeoVim](https://github.com/neovim/neovim) - Text Editor

### PowerShell
- [PowerShell](https://apps.microsoft.com/detail/9MZ1SNWT0N5D)
- [Oh-My-Posh](https://github.com/JanDeDobbeleer/oh-my-posh) - Makes the terminal looks nicer
- [Get-ChildItemColor](https://github.com/joonro/Get-ChildItemColor) - ls with colors
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) - ls with icons
