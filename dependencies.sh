#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Standalone Dependency Installer         ║
# ╚══════════════════════════════════════════════════════╝
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()   { echo -e "${GREEN}[HLRF]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
info()  { echo -e "${CYAN}[INFO]${NC} $*"; }

PACMAN_PACKAGES=(
    hyprland waybar rofi-wayland kitty thunar
    swaync hyprlock hypridle
    swww grim slurp wl-clipboard cliphist
    pipewire wireplumber pavucontrol playerctl
    networkmanager nm-connection-editor bluez bluez-utils blueman
    qt5ct qt6ct papirus-icon-theme
    ttf-jetbrains-mono-nerd noto-fonts-emoji
    xdg-desktop-portal-hyprland polkit-gnome
    jq brightnessctl wf-recorder wlsunset xorg-xwayland
)

AUR_PACKAGES=(
    bibata-cursor-theme
)

log "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# AUR
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    AUR_HELPER=""
fi

if [ -n "$AUR_HELPER" ]; then
    log "Installing AUR packages via $AUR_HELPER..."
    "$AUR_HELPER" -S --needed --noconfirm "${AUR_PACKAGES[@]}"
else
    warn "No AUR helper found. Install manually: ${AUR_PACKAGES[*]}"
fi

# Enable services
sudo systemctl enable --now NetworkManager 2>/dev/null || true
sudo systemctl enable --now bluetooth 2>/dev/null || true
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

log "All dependencies installed ✓"
