#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# Mobile Antigravity - One-Click Setup Script
# https://github.com/mobileantigravity/Mobile-Antigravity
# ============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       Mobile Antigravity Setup           ║${NC}"
echo -e "${CYAN}║  Google Antigravity CLI on Android       ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

step() {
  echo -e "${GREEN}▶ $1${NC}"
}

info() {
  echo -e "${YELLOW}  $1${NC}"
}

error() {
  echo -e "${RED}✗ Error: $1${NC}"
  exit 1
}

# ── Step 1: Update Termux ──────────────────────────────────
step "Step 1/9 — Updating Termux packages..."
pkg update -y || error "pkg update failed. Make sure you installed Termux from F-Droid."
echo ""

# ── Step 2: Install proot-distro ──────────────────────────
step "Step 2/9 — Installing proot-distro..."
pkg install proot-distro -y || error "Failed to install proot-distro."
echo ""

# ── Step 3: Install Ubuntu ────────────────────────────────
step "Step 3/9 — Installing Ubuntu (this may take a moment)..."
proot-distro install ubuntu 2>/dev/null || info "Ubuntu already installed, skipping."
echo ""

# ── Step 4: Create inner setup script ────────────────────
step "Step 4/9 — Preparing Ubuntu environment script..."
cat > /tmp/ubuntu_setup.sh << 'INNER_SCRIPT'
#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}▶ Step 5/9 — Updating Ubuntu packages...${NC}"
apt update -y

echo -e "${CYAN}▶ Step 6/9 — Installing curl and git...${NC}"
apt install curl git -y

echo -e "${CYAN}▶ Step 7/9 — Installing Google Antigravity CLI...${NC}"
curl -fsSL https://antigravity.google/cli/install.sh | bash

echo -e "${CYAN}▶ Step 8/9 — Verifying installation...${NC}"
~/.local/bin/agy --version && echo -e "${GREEN}✓ agy installed successfully!${NC}"

echo -e "${CYAN}▶ Step 9/9 — Adding agy to PATH...${NC}"
export PATH="/root/.local/bin:$PATH"
grep -qxF 'export PATH="/root/.local/bin:$PATH"' ~/.bashrc || \
  echo 'export PATH="/root/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        ✅  Setup Complete!               ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║  Run:  agy                               ║${NC}"
echo -e "${GREEN}║  Then select: Google OAuth               ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
INNER_SCRIPT

chmod +x /tmp/ubuntu_setup.sh

# ── Step 5: Run inside Ubuntu ─────────────────────────────
step "Running setup inside Ubuntu..."
proot-distro login ubuntu -- bash /tmp/ubuntu_setup.sh

echo ""
echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo -e "${GREEN}  All done! To use Antigravity next time:${NC}"
echo ""
echo -e "  1. Open Termux"
echo -e "  2. Run: ${CYAN}proot-distro login ubuntu${NC}"
echo -e "  3. Run: ${CYAN}agy${NC}"
echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo ""
