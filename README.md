# dotfiles

Personal shell and terminal configuration for macOS and Linux.

This repo contains the author's day-to-day setup for:

- zsh/bash shell behavior
- aliases and helper functions
- tmux + gitmux status line setup
- Starship prompt
- development tool bootstrap scripts

It is optimized for personal use first, but can be reused as a base for your own setup.

## What is in this repo

- `.bash_profile`, `.bashrc`, `.zshrc`, `.zprofile`
- `.aliases`, `.functions`, `.exports`, `.extend`
- `.tmux.conf.local`, `.gitmux.yaml`
- `starship.toml`
- `.gitconfig`, `.gitignore`, `.editorconfig`
- `bootstrap.sh` (symlink/install script)
- `setup-macos.sh` and `setup-linux.sh` (dependency installers)
- `.vscode/settings.json` (editor quality-of-life settings)

## Supported platforms

- macOS (primary)
- Linux (apt/dnf/yum/pacman supported by setup script)

## Quick start

1) Clone

```bash
git clone https://github.com/zkwokleung/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

2) Install dependencies

On macOS:

```bash
./setup-macos.sh
```

On Linux:

```bash
./setup-linux.sh
```

3) Apply dotfiles

```bash
./bootstrap.sh
```

Use `./bootstrap.sh --force` to skip the confirmation prompt.

4) Reload shell

```bash
source ~/.zshrc
# or
source ~/.bashrc
```

## What bootstrap does

`bootstrap.sh`:

- symlinks dotfiles from this repo into your home directory
- backs up existing non-symlink files as `*.bak`
- creates `~/.config/tmux` and links:
  - `~/.config/tmux/tmux.conf.local`
  - `~/.config/tmux/gitmux.conf`
- links `starship.toml` to `~/.config/starship.toml`
- applies git color + pager settings (diff-so-fancy if installed)

## Default behavior and notable setup

- `cd` is aliased to `z` (zoxide-based navigation)
- interactive zsh shells source `~/.bash_profile`
- tmux auto-attaches/creates session `main` for interactive terminal shells
- prompt uses Starship when available, with fallback prompt if missing
- common tools are wired through aliases (`eza`, `bat`, `rg`, `nvim`, `git` helpers)

## Selected aliases

From `.aliases`:

- navigation: `..`, `...`, `p`, `dot`, `d`
- git: `g`, `ga`, `gaa`, `gs`, `gf`, `gc`, `gcm`, `gp`, `gpo`, `gL`, `glo`, `gl`
- editor: `v`, `vi`, `vim`, `v.`
- shell helpers: `rl`, `cls`, `clip`
- zoxide helpers: `zi`, `zq`, `za`, `zr`, `ze`

## Selected functions

From `.functions`:

- `o` open current path in file manager (`open`/`xdg-open`)
- `cdls` change directory then list contents
- `tre` tree view with useful ignores
- `weather`, `future-weather`, `moon-phase`
- `ovpn <country_code>` connect to OpenVPN profile in `~/OpenVPN`
- `cl [config]` launch Claude Code with optional profile dir

## Customization

Update these files directly:

- aliases: `.aliases`
- functions: `.functions`
- environment variables / PATH: `.exports`
- prompt: `starship.toml`
- tmux look/behavior: `.tmux.conf.local` and `.gitmux.yaml`

Then reload:

```bash
source ~/.zshrc
```

or

```bash
source ~/.bashrc
```

## Updating

Pull latest changes and re-run bootstrap:

```bash
cd ~/Projects/dotfiles
git pull
./bootstrap.sh --force
```

## Safety notes

- review scripts before running on your machine
- bootstrap may overwrite files in `$HOME` (it creates `*.bak` for existing regular files)
- setup scripts install many packages; trim them to your needs

## Troubleshooting

- `command not found` after setup: restart terminal or source shell config again
- Starship not loading: ensure `starship` is installed and `~/.config/starship.toml` exists
- tmux not auto-starting: check `tmux` exists and terminal is not already inside tmux
- zoxide navigation oddities: remember `cd` is aliased to `z`; use `builtin cd` if needed

## Credits

Originally based on [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles), then heavily customized for this workflow.
