#!/bin/bash

# ============================================================
#  Install Audio Driver — hype5x3
#  Installs VoodooHDA.kext to /Library/Extensions
#  and rebuilds the kext cache so audio works immediately.
# ============================================================

KEXT_NAME="VoodooHDA.kext"
KEXT_DEST="/Library/Extensions"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_KEXT="$SCRIPT_DIR/bin/$KEXT_NAME"

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
echo -e "${CYAN}${BOLD}║      Audio Driver Installer — hype5x3           ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Installs: ${BOLD}VoodooHDA.kext${NC} → /Library/Extensions"
echo ""

# ── Preflight check ──────────────────────────────────────────
echo -e "${BOLD}[ 1/4 ] Checking source kext...${NC}"
if [[ ! -d "$SOURCE_KEXT" ]]; then
    echo -e "${RED}  ✗ Cannot find '$SOURCE_KEXT'${NC}"
    echo -e "${RED}    Make sure you're running this from the tools/ folder.${NC}"
    echo ""
    read -rp "Press Enter to exit..."
    exit 1
fi
echo -e "${GREEN}  ✓ Found: $SOURCE_KEXT${NC}"
echo ""

# ── Remove old installation if present ───────────────────────
echo -e "${BOLD}[ 2/4 ] Installing VoodooHDA.kext to $KEXT_DEST...${NC}"
echo -e "${YELLOW}  → You may be prompted for your password (sudo required).${NC}"
echo ""

if [[ -d "$KEXT_DEST/$KEXT_NAME" ]]; then
    echo -e "${YELLOW}  → Removing old $KEXT_NAME...${NC}"
    sudo rm -rf "$KEXT_DEST/$KEXT_NAME"
fi

sudo cp -R "$SOURCE_KEXT" "$KEXT_DEST/$KEXT_NAME"
if [[ $? -ne 0 ]]; then
    echo -e "${RED}  ✗ Failed to copy kext.${NC}"
    read -rp "Press Enter to exit..."
    exit 1
fi
echo -e "${GREEN}  ✓ Copied: $KEXT_DEST/$KEXT_NAME${NC}"
echo ""

# ── Fix permissions ──────────────────────────────────────────
echo -e "${BOLD}[ 3/4 ] Setting kext permissions...${NC}"
sudo chown -R root:wheel "$KEXT_DEST/$KEXT_NAME"
sudo chmod -R 755 "$KEXT_DEST/$KEXT_NAME"
echo -e "${GREEN}  ✓ Permissions set (root:wheel, 755)${NC}"
echo ""

# ── Rebuild kext cache ───────────────────────────────────────
echo -e "${BOLD}[ 4/4 ] Rebuilding kext cache...${NC}"
echo -e "${YELLOW}  → This may take a moment...${NC}"
sudo kmutil install --volume-root / --update-all 2>/dev/null \
    || sudo kextcache -i / 2>/dev/null \
    || sudo touch /Library/Extensions
if [[ $? -ne 0 ]]; then
    echo -e "${YELLOW}  ⚠  Cache rebuild returned non-zero (this can be normal on Ventura+).${NC}"
else
    echo -e "${GREEN}  ✓ Kext cache rebuilt${NC}"
fi
echo ""

echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║          Installation Complete! 🎉               ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}⚠  A restart is required for audio to work.${NC}"
echo -e "  After reboot, audio should appear in System Settings → Sound."
echo ""

read -rp "Press Enter to close (then restart your Mac)..."
