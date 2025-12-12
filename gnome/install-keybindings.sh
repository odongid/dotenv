#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────────
#                     GNOME KEYBINDINGS INSTALLER
# ─────────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYBINDINGS_FILE="$SCRIPT_DIR/keybindings.dconf"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Extensions to install
declare -A EXTENSIONS=(
    ["clipboard-history@alexsaveau.dev"]="4839"
    ["tiling-assistant@leleat-on-github"]="3733"
    ["rounded-window-corners@fxgn"]="7048"
)

echo -e "${GREEN}GNOME Keybindings Installer${NC}"
echo "─────────────────────────────────"

install_extension() {
    local uuid="$1"
    local ext_id="$2"
    local name=$(echo "$uuid" | cut -d'@' -f1)

    echo -e "${BLUE}Checking $name extension...${NC}"

    if gnome-extensions list 2>/dev/null | grep -q "$uuid"; then
        echo -e "${GREEN}✓ $name already installed${NC}"
    else
        echo -e "${YELLOW}Installing $name extension...${NC}"

        # Get GNOME Shell version
        GNOME_VERSION=$(gnome-shell --version | grep -oP '\d+' | head -1)

        # Download extension info to get download URL
        EXT_INFO=$(curl -s "https://extensions.gnome.org/extension-info/?pk=$ext_id&shell_version=$GNOME_VERSION")

        if [[ -z "$EXT_INFO" || "$EXT_INFO" == *"error"* ]]; then
            echo -e "${RED}✗ Could not fetch extension info. Install manually:${NC}"
            echo "  https://extensions.gnome.org/extension/$ext_id/"
            return 1
        fi

        # Extract download URL
        DOWNLOAD_URL=$(echo "$EXT_INFO" | grep -oP '"download_url"\s*:\s*"\K[^"]+')

        if [[ -z "$DOWNLOAD_URL" ]]; then
            echo -e "${RED}✗ Extension not available for GNOME $GNOME_VERSION${NC}"
            echo "  Install manually via Extension Manager"
            return 1
        fi

        # Download and install
        TMP_ZIP="/tmp/${name}.zip"
        curl -sL "https://extensions.gnome.org$DOWNLOAD_URL" -o "$TMP_ZIP"

        if [[ -f "$TMP_ZIP" ]]; then
            gnome-extensions install "$TMP_ZIP" --force
            rm "$TMP_ZIP"
            echo -e "${GREEN}✓ $name installed${NC}"
        else
            echo -e "${RED}✗ Download failed${NC}"
            return 1
        fi
    fi

    # Enable extension
    if ! gnome-extensions list --enabled 2>/dev/null | grep -q "$uuid"; then
        echo -e "${BLUE}Enabling $name extension...${NC}"
        gnome-extensions enable "$uuid" 2>/dev/null || true
    fi
}

case "${1:-install}" in
    install|load)
        if [[ ! -f "$KEYBINDINGS_FILE" ]]; then
            echo -e "${RED}Error: keybindings.dconf not found${NC}"
            exit 1
        fi

        # Install all extensions
        for uuid in "${!EXTENSIONS[@]}"; do
            install_extension "$uuid" "${EXTENSIONS[$uuid]}"
        done
        echo ""

        # Load keybindings
        echo -e "Loading keybindings from: ${YELLOW}$KEYBINDINGS_FILE${NC}"
        dconf load / < "$KEYBINDINGS_FILE"
        echo -e "${GREEN}✓ Keybindings loaded successfully!${NC}"
        echo ""
        echo "Configured shortcuts:"
        echo "  Alt+T           → Launch Kitty"
        echo "  Alt+C           → Close window"
        echo "  Alt+Arrows      → Focus window in direction (i3-style)"
        echo "  Alt+D           → Application search"
        echo "  Alt+F           → Toggle fullscreen"
        echo "  Shift+Alt+Arrow → Tile/move windows"
        echo "  Shift+Super+S   → Screenshot area → clipboard"
        echo "  Super+D         → Show desktop"
        echo "  Super+V         → Clipboard history"
        echo ""
        echo -e "${YELLOW}Note: You may need to log out/in for new extensions to work${NC}"
        ;;

    export|dump)
        echo -e "Exporting current keybindings to: ${YELLOW}$KEYBINDINGS_FILE${NC}"
        {
            echo "# ─────────────────────────────────────────────────────────────────────────────────"
            echo "#                           GNOME KEYBINDINGS"
            echo "# ─────────────────────────────────────────────────────────────────────────────────"
            echo "# Exported on $(date)"
            echo ""
            echo "[org/gnome/settings-daemon/plugins/media-keys]"
            dconf dump /org/gnome/settings-daemon/plugins/media-keys/
            echo ""
            echo "[org/gnome/desktop/wm/keybindings]"
            dconf dump /org/gnome/desktop/wm/keybindings/
            echo ""
            echo "[org/gnome/shell/keybindings]"
            dconf dump /org/gnome/shell/keybindings/
            echo ""
            echo "[org/gnome/shell/extensions/tiling-assistant]"
            dconf dump /org/gnome/shell/extensions/tiling-assistant/
            echo ""
            echo "[org/gnome/shell/extensions/clipboard-history]"
            dconf dump /org/gnome/shell/extensions/clipboard-history/
            echo ""
            echo "[org/gnome/shell/extensions/rounded-window-corners-reborn]"
            dconf dump /org/gnome/shell/extensions/rounded-window-corners-reborn/
        } > "$KEYBINDINGS_FILE"
        echo -e "${GREEN}✓ Keybindings exported!${NC}"
        ;;

    *)
        echo "Usage: $0 [install|export]"
        echo "  install  Install extensions and load keybindings (default)"
        echo "  export   Save current GNOME keybindings to dconf file"
        ;;
esac
