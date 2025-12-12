# Dotenv

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=flat-square&logo=zsh&logoColor=white)
![Vim](https://img.shields.io/badge/Vim-019733?style=flat-square&logo=vim&logoColor=white)
![Kitty](https://img.shields.io/badge/Kitty-000000?style=flat-square&logo=kitty&logoColor=white)
![GNOME](https://img.shields.io/badge/GNOME-4A86CF?style=flat-square&logo=gnome&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)

Personal dotfiles and shell configurations. Cross-distro compatible.

## Compatibility

| Component | Arch | Fedora | Debian/Ubuntu | macOS |
|-----------|:----:|:------:|:-------------:|:-----:|
| zsh       | ✓    | ✓      | ✓             | ✓     |
| vim       | ✓    | ✓      | ✓             | ✓     |
| kitty     | ✓    | ✓      | ✓             | ✓     |
| fzf       | ✓    | ✓      | ✓             | ✓     |
| nvm       | ✓    | ✓      | ✓             | ✓     |
| gnome     | ✓    | ✓      | ✓             | -     |
| git       | ✓    | ✓      | ✓             | ✓     |

## Quick Start

```bash
# Clone the repo
git clone git@github.com:Dxsk/dotenv.git ~/Documents/dotenv

# Run the installer
cd ~/Documents/dotenv && ./install.sh
```

That's it! The installer handles everything: symlinks, GNOME extensions, keybindings, etc.

## Dependencies

Install these packages first:

```bash
# Arch
sudo pacman -S zsh vim kitty fzf git

# Fedora
sudo dnf install zsh vim kitty fzf git

# Debian/Ubuntu
sudo apt install zsh vim kitty fzf git

# macOS (Homebrew)
brew install zsh vim kitty fzf git
```

Optional:
- [Oh My Zsh](https://ohmyz.sh/) - zsh framework
- [nvm](https://github.com/nvm-sh/nvm) - Node version manager

## Features

- **Custom color theme** - Kanagawa x Gruvbox inspired dark theme with orange/red/violet accents
- **Zsh configurations** - Modular shell setup with useful functions and aliases
- **Directory navigation** - `back` command with history stack and fzf integration
- **Workstation aliases** - Shortcuts for dnf, systemd, podman, python venvs, and more
- **GNOME keybindings** - i3-style window management (Alt+Arrows for focus, Shift+Alt+Arrows for tiling)
- **Git multi-domain** - Automatic email switching between GitHub and GitLab

## Installation Options

```bash
./install.sh              # Install everything
./install.sh zsh          # Install only zsh config
./install.sh vim          # Install only vim config
./install.sh kitty        # Install only kitty config
./install.sh gnome        # Install GNOME keybindings & extensions
./install.sh git          # Install git config
./install.sh export-git   # Export current git config to repo
```

## Structure

```
dotenv/
├── install.sh                    # Main installer
├── git/
│   ├── gitconfig                 # Main git config
│   ├── gitconfig-github          # GitHub-specific (email)
│   └── gitconfig-gitlab          # GitLab-specific (email)
├── gnome/
│   ├── install-keybindings.sh    # GNOME extensions & keybindings installer
│   └── keybindings.dconf         # Exported keybindings
├── gnome-extensions/
│   └── focus-highlight@custom/   # Window focus border extension
├── kitty/
│   └── kitty.conf                # Kitty terminal config
├── vim/
│   ├── vimrc                     # Vim configuration
│   └── colors/
│       └── kanagawa-gruvbox.vim  # Custom colorscheme
└── zsh/
    ├── colors.zsh                # Hex color preview functions
    ├── fzf.zsh                   # Fzf config (cross-distro)
    ├── kitty.zsh                 # Kitty terminal integration
    ├── navigation.zsh            # Directory history & back command
    ├── nvm.zsh                   # Node Version Manager
    └── workstation.zsh           # System aliases & functions
```

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| ![Background](https://img.shields.io/badge/-%231f1f28?style=flat-square&color=1f1f28) | `#1f1f28` | Background |
| ![Foreground](https://img.shields.io/badge/-%23dcd7ba?style=flat-square&color=dcd7ba) | `#dcd7ba` | Foreground |
| ![Red](https://img.shields.io/badge/-%23ff5d62?style=flat-square&color=ff5d62) | `#ff5d62` | Red |
| ![Orange](https://img.shields.io/badge/-%23ff7733?style=flat-square&color=ff7733) | `#ff7733` | Orange |
| ![Yellow](https://img.shields.io/badge/-%23d8a657?style=flat-square&color=d8a657) | `#d8a657` | Yellow |
| ![Green](https://img.shields.io/badge/-%2398bb6c?style=flat-square&color=98bb6c) | `#98bb6c` | Green |
| ![Blue](https://img.shields.io/badge/-%237fb4ca?style=flat-square&color=7fb4ca) | `#7fb4ca` | Blue |
| ![Violet](https://img.shields.io/badge/-%23c678dd?style=flat-square&color=c678dd) | `#c678dd` | Violet |
| ![Pink](https://img.shields.io/badge/-%23ff79c6?style=flat-square&color=ff79c6) | `#ff79c6` | Pink |

## GNOME Keybindings

| Shortcut | Action |
|----------|--------|
| `Alt+T` | Launch Kitty terminal |
| `Alt+C` | Close window |
| `Alt+D` | Application search |
| `Alt+F` | Toggle fullscreen |
| `Alt+Arrows` | Focus window in direction (i3-style) |
| `Shift+Alt+Left/Right` | Tile window left/right (50%) |
| `Shift+Alt+Up` | Maximize window |
| `Shift+Alt+Down` | Restore window |
| `Super+D` | Show desktop |
| `Super+V` | Clipboard history |
| `Shift+Super+S` | Screenshot area to clipboard |

## Zsh Functions

### Navigation

| Command | Description |
|---------|-------------|
| `back` | Go to previous directory in history |
| `back -a` | Select directory from history with fzf |

### Python / Venv

| Command | Description |
|---------|-------------|
| `venv [name]` | Create and activate a venv |
| `va [name]` | Activate existing venv |
| `venv-init` | Create venv + install requirements.txt |
| `venv-info` | Show active venv info |

### System

| Command | Description |
|---------|-------------|
| `maj` | System update (dnf) |
| `majall` | Full update (dnf + flatpak + firmware) |
| `cleanup` | Full system cleanup |
| `sysinfo` | Display system information |

### Podman

| Command | Description |
|---------|-------------|
| `pps` / `ppsa` | List containers |
| `psh` / `pbash` | Interactive shell into container (fzf) |
| `pstatus` | Full podman overview |
| `pcleanall` | Stop and remove all containers |

> Type `ws-help` or `podman-help` for full command reference.

## License

MIT
