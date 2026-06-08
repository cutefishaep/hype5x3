#!/bin/bash

# ============================================================
#  Install WiFi Driver — hype5x3
#  1. Installs rtw88ctl to /usr/local/bin
#  2. Copies Starskiff.app to /Applications
#  3. Registers Starskiff.app as a Login Item
# ============================================================

TOOL_NAME="rtw88ctl"
APP_NAME="Starskiff.app"
INSTALL_DIR="/usr/local/bin"
APPLICATIONS_DIR="/Applications"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_BIN="$SCRIPT_DIR/bin/$TOOL_NAME"
SOURCE_APP="$SCRIPT_DIR/bin/$APP_NAME"

# ── Colours ─────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Banner ───────────────────────────────────────────────────
clear
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║       WiFi Driver Installer — hype5x3           ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Installs: ${BOLD}rtw88ctl${NC} CLI + ${BOLD}Starskiff.app${NC} (login item)"
echo ""

# ── Preflight ────────────────────────────────────────────────
ERRORS=0

echo -e "${BOLD}[ 1/5 ] Checking source files...${NC}"
if [[ ! -f "$SOURCE_BIN" ]]; then
    echo -e "${RED}  ✗ Cannot find '$SOURCE_BIN'${NC}"
    ERRORS=1
else
    echo -e "${GREEN}  ✓ Found: $SOURCE_BIN${NC}"
fi

if [[ ! -d "$SOURCE_APP" ]]; then
    echo -e "${RED}  ✗ Cannot find '$SOURCE_APP'${NC}"
    ERRORS=1
else
    echo -e "${GREEN}  ✓ Found: $SOURCE_APP${NC}"
fi

if [[ $ERRORS -ne 0 ]]; then
    echo ""
    echo -e "${RED}  Make sure you're running this from the tools/ folder.${NC}"
    read -rp "Press Enter to exit..."
    exit 1
fi
echo ""

# ── Ensure /usr/local/bin exists ─────────────────────────────
echo -e "${BOLD}[ 2/5 ] Preparing install directories...${NC}"
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}  → Creating $INSTALL_DIR (requires sudo)${NC}"
    sudo mkdir -p "$INSTALL_DIR"
fi
echo -e "${GREEN}  ✓ $INSTALL_DIR is ready${NC}"
echo ""

# ── Install rtw88ctl ─────────────────────────────────────────
echo -e "${BOLD}[ 3/5 ] Installing $TOOL_NAME to $INSTALL_DIR...${NC}"
echo -e "${YELLOW}  → You may be prompted for your password (sudo required).${NC}"
echo ""
sudo install -m 755 "$SOURCE_BIN" "$INSTALL_DIR/$TOOL_NAME"
if [[ $? -ne 0 ]]; then
    echo -e "${RED}  ✗ Failed to install $TOOL_NAME.${NC}"
    read -rp "Press Enter to exit..."
    exit 1
fi
echo -e "${GREEN}  ✓ Installed: $INSTALL_DIR/$TOOL_NAME${NC}"
echo ""

# ── Copy Starskiff.app to /Applications ──────────────────────
echo -e "${BOLD}[ 4/5 ] Installing $APP_NAME to $APPLICATIONS_DIR...${NC}"
if [[ -d "$APPLICATIONS_DIR/$APP_NAME" ]]; then
    echo -e "${YELLOW}  → Removing previous installation...${NC}"
    sudo rm -rf "$APPLICATIONS_DIR/$APP_NAME"
fi
sudo cp -R "$SOURCE_APP" "$APPLICATIONS_DIR/$APP_NAME"
if [[ $? -ne 0 ]]; then
    echo -e "${RED}  ✗ Failed to copy $APP_NAME.${NC}"
    read -rp "Press Enter to exit..."
    exit 1
fi
echo -e "${GREEN}  ✓ Installed: $APPLICATIONS_DIR/$APP_NAME${NC}"
echo ""

# ── Register Starskiff.app as Login Item ─────────────────────
echo -e "${BOLD}[ 5/5 ] Registering Starskiff as a Login Item...${NC}"
osascript <<'APPLESCRIPT'
tell application "System Events"
    set loginItems to name of every login item
    if "Starskiff" is not in loginItems then
        make login item at end with properties {path:"/Applications/Starskiff.app", hidden:false}
    end if
end tell
APPLESCRIPT

if [[ $? -ne 0 ]]; then
    echo -e "${YELLOW}  ⚠  Could not add login item automatically.${NC}"
    echo -e "${YELLOW}     Please add Starskiff manually:${NC}"
    echo -e "${YELLOW}     System Settings → General → Login Items → Add +${NC}"
else
    echo -e "${GREEN}  ✓ Starskiff.app added to Login Items (starts at login)${NC}"
fi
echo ""

# ── Verify ───────────────────────────────────────────────────
if command -v "$TOOL_NAME" &>/dev/null; then
    echo -e "${GREEN}  ✓ '$TOOL_NAME' is available in your PATH.${NC}"
else
    echo -e "${YELLOW}  ⚠  '$TOOL_NAME' not found in PATH yet.${NC}"
    echo -e "${YELLOW}     Add to ~/.zshrc: export PATH=\"/usr/local/bin:\$PATH\"${NC}"
fi

echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║          Installation Complete! 🎉               ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "  • Starskiff will start automatically on next login"
echo -e "  • Use ${CYAN}rtw88ctl --help${NC} in Terminal for driver control"
echo ""

read -rp "Press Enter to close..."
