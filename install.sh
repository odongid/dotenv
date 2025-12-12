#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────────
#                           DOTENV INSTALLER
# ─────────────────────────────────────────────────────────────────────────────────
# Installs all configurations from this repo
# Usage: ./install.sh [component]
# Components: all, zsh, vim, kitty, gnome, git

DOTENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}Dotenv Installer${NC}"
echo "─────────────────────────────────"

# ─────────────────────────────────────────────────────────────────────────────────
# Helper functions
# ─────────────────────────────────────────────────────────────────────────────────

backup_file() {
    local file="$1"
    if [[ -f "$file" && ! -L "$file" ]]; then
        local backup="$file.backup.$(date +%Y%m%d%H%M%S)"
        cp "$file" "$backup"
        echo -e "  Backup: ${YELLOW}$backup${NC}"
    fi
}

create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        rm "$dest"
    elif [[ -f "$dest" ]]; then
        backup_file "$dest"
        rm "$dest"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓${NC} $dest → $src"
}

# ─────────────────────────────────────────────────────────────────────────────────
# ZSH Installation
# ─────────────────────────────────────────────────────────────────────────────────

install_zsh() {
    echo -e "\n${BLUE}[ZSH]${NC} Installing zsh configuration..."

    local ZSHRC="$HOME/.zshrc"
    local MARKER="# DOTENV - Custom configurations"

    if grep -q "$MARKER" "$ZSHRC" 2>/dev/null; then
        echo -e "  ${YELLOW}Already installed${NC}"
        return 0
    fi

    backup_file "$ZSHRC"

    cat >> "$ZSHRC" << 'EOF'

# ─────────────────────────────────────────────────────────────────────────────────
# DOTENV - Custom configurations
# ─────────────────────────────────────────────────────────────────────────────────
DOTENV_DIR="$HOME/Documents/dotenv/zsh"
if [[ -d "$DOTENV_DIR" ]]; then
    for config in "$DOTENV_DIR"/*.zsh(N); do
        source "$config"
    done
fi
EOF

    echo -e "  ${GREEN}✓${NC} Loader added to .zshrc"
    echo -e "  Configs: $(ls "$DOTENV_ROOT/zsh"/*.zsh 2>/dev/null | wc -l) files"
}

# ─────────────────────────────────────────────────────────────────────────────────
# VIM Installation
# ─────────────────────────────────────────────────────────────────────────────────

install_vim() {
    echo -e "\n${BLUE}[VIM]${NC} Installing vim configuration..."

    # Create vim directories
    mkdir -p "$HOME/.vim/colors"
    mkdir -p "$HOME/.vim/undodir"

    # Symlink vimrc
    create_symlink "$DOTENV_ROOT/vim/vimrc" "$HOME/.vimrc"

    # Symlink colorschemes
    for colorfile in "$DOTENV_ROOT/vim/colors"/*.vim; do
        if [[ -f "$colorfile" ]]; then
            local name=$(basename "$colorfile")
            create_symlink "$colorfile" "$HOME/.vim/colors/$name"
        fi
    done
}

# ─────────────────────────────────────────────────────────────────────────────────
# KITTY Installation
# ─────────────────────────────────────────────────────────────────────────────────

install_kitty() {
    echo -e "\n${BLUE}[KITTY]${NC} Installing kitty configuration..."

    mkdir -p "$HOME/.config/kitty"
    create_symlink "$DOTENV_ROOT/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
}

# ─────────────────────────────────────────────────────────────────────────────────
# GNOME Installation
# ─────────────────────────────────────────────────────────────────────────────────

install_gnome() {
    echo -e "\n${BLUE}[GNOME]${NC} Installing GNOME keybindings and extensions..."

    if [[ -f "$DOTENV_ROOT/gnome/install-keybindings.sh" ]]; then
        bash "$DOTENV_ROOT/gnome/install-keybindings.sh" install
    else
        echo -e "  ${RED}✗${NC} install-keybindings.sh not found"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# GIT Installation
# ─────────────────────────────────────────────────────────────────────────────────

install_git() {
    echo -e "\n${BLUE}[GIT]${NC} Installing git configuration..."

    if [[ -f "$DOTENV_ROOT/git/gitconfig" ]]; then
        create_symlink "$DOTENV_ROOT/git/gitconfig" "$HOME/.gitconfig"
    fi

    if [[ -f "$DOTENV_ROOT/git/gitconfig-github" ]]; then
        create_symlink "$DOTENV_ROOT/git/gitconfig-github" "$HOME/.gitconfig-github"
    fi

    if [[ -f "$DOTENV_ROOT/git/gitconfig-gitlab" ]]; then
        create_symlink "$DOTENV_ROOT/git/gitconfig-gitlab" "$HOME/.gitconfig-gitlab"
    fi

    # Check if any git configs were installed
    if [[ ! -f "$DOTENV_ROOT/git/gitconfig" ]]; then
        echo -e "  ${YELLOW}No git config in repo. Run './install.sh export-git' to export current config.${NC}"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# Export current git config to repo
# ─────────────────────────────────────────────────────────────────────────────────

export_git() {
    echo -e "\n${BLUE}[GIT]${NC} Exporting git configuration to repo..."

    mkdir -p "$DOTENV_ROOT/git"

    if [[ -f "$HOME/.gitconfig" ]]; then
        cp "$HOME/.gitconfig" "$DOTENV_ROOT/git/gitconfig"
        echo -e "  ${GREEN}✓${NC} Exported .gitconfig"
    fi

    if [[ -f "$HOME/.gitconfig-github" ]]; then
        cp "$HOME/.gitconfig-github" "$DOTENV_ROOT/git/gitconfig-github"
        echo -e "  ${GREEN}✓${NC} Exported .gitconfig-github"
    fi

    if [[ -f "$HOME/.gitconfig-gitlab" ]]; then
        cp "$HOME/.gitconfig-gitlab" "$DOTENV_ROOT/git/gitconfig-gitlab"
        echo -e "  ${GREEN}✓${NC} Exported .gitconfig-gitlab"
    fi

    echo -e "  ${YELLOW}Don't forget to commit the git/ folder${NC}"
}

# ─────────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────────

install_all() {
    install_zsh
    install_vim
    install_kitty
    install_git
    install_gnome

    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "  • Restart your terminal or run: source ~/.zshrc"
    echo "  • Log out/in if GNOME extensions were installed"
    echo ""
}

case "${1:-all}" in
    all)        install_all ;;
    zsh)        install_zsh ;;
    vim)        install_vim ;;
    kitty)      install_kitty ;;
    gnome)      install_gnome ;;
    git)        install_git ;;
    export-git) export_git ;;
    *)
        echo "Usage: $0 [component]"
        echo ""
        echo "Components:"
        echo "  all         Install everything (default)"
        echo "  zsh         Install zsh configuration"
        echo "  vim         Install vim configuration"
        echo "  kitty       Install kitty configuration"
        echo "  gnome       Install GNOME keybindings & extensions"
        echo "  git         Install git configuration"
        echo "  export-git  Export current git config to repo"
        ;;
esac
