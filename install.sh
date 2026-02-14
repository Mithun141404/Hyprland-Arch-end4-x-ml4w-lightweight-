#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite Rice Framework — Installer                ║
# ╚══════════════════════════════════════════════════════╝
set -euo pipefail

# ── Colors ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/config"
BACKUP_DIR="$HOME/.config-backup-hlrf-$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
UNINSTALL=false
SKIP_DEPS=false

# ── Helpers ────────────────────────────────────────────
log()   { echo -e "${GREEN}[HLRF]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
info()  { echo -e "${CYAN}[INFO]${NC} $*"; }

usage() {
    cat << EOF
${BOLD}HyprLite Rice Framework — Installer${NC}

Usage: $0 [OPTIONS]

Options:
  --dry-run       Show what would be done without making changes
  --uninstall     Restore backed-up configs and remove HLRF configs
  --skip-deps     Skip dependency installation
  -h, --help      Show this help message

EOF
    exit 0
}

# ── Parse Arguments ────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)    DRY_RUN=true ;;
        --uninstall)  UNINSTALL=true ;;
        --skip-deps)  SKIP_DEPS=true ;;
        -h|--help)    usage ;;
        *) error "Unknown option: $1"; usage ;;
    esac
    shift
done

# ── System Check ───────────────────────────────────────
check_system() {
    if [ ! -f /etc/arch-release ]; then
        warn "This installer is designed for Arch Linux."
        read -rp "Continue anyway? [y/N] " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    fi
    log "Arch Linux detected ✓"
}

# ── Dependency Installation ────────────────────────────
PACMAN_PACKAGES=(
    # Core
    hyprland
    waybar
    rofi-wayland
    kitty
    thunar

    # Notifications / Lock / Idle
    swaync
    hyprlock
    hypridle

    # Wallpaper / Screenshot / Clipboard
    swww
    grim
    slurp
    wl-clipboard
    cliphist

    # Audio
    pipewire
    wireplumber
    pavucontrol
    playerctl

    # Network / Bluetooth
    networkmanager
    nm-connection-editor
    bluez
    bluez-utils
    blueman

    # Theming
    qt5ct
    qt6ct
    papirus-icon-theme

    # Fonts
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji

    # Portal / Polkit
    xdg-desktop-portal-hyprland
    polkit-gnome

    # Utilities
    jq
    brightnessctl
    wf-recorder
    wlsunset

    # XWayland
    xorg-xwayland
)

AUR_PACKAGES=(
    bibata-cursor-theme
)

detect_aur_helper() {
    if command -v paru &>/dev/null; then
        echo "paru"
    elif command -v yay &>/dev/null; then
        echo "yay"
    else
        echo ""
    fi
}

install_dependencies() {
    if $SKIP_DEPS; then
        info "Skipping dependency installation (--skip-deps)"
        return
    fi

    log "Installing pacman packages..."
    if $DRY_RUN; then
        info "[DRY-RUN] Would install: ${PACMAN_PACKAGES[*]}"
    else
        sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
    fi

    local aur_helper
    aur_helper=$(detect_aur_helper)

    if [ -n "$aur_helper" ]; then
        log "Installing AUR packages via $aur_helper..."
        if $DRY_RUN; then
            info "[DRY-RUN] Would install (AUR): ${AUR_PACKAGES[*]}"
        else
            "$aur_helper" -S --needed --noconfirm "${AUR_PACKAGES[@]}"
        fi
    else
        warn "No AUR helper found (yay/paru). Please install these manually:"
        for pkg in "${AUR_PACKAGES[@]}"; do
            echo "  - $pkg"
        done
    fi

    # Enable services
    if ! $DRY_RUN; then
        sudo systemctl enable --now NetworkManager 2>/dev/null || true
        sudo systemctl enable --now bluetooth 2>/dev/null || true
        systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
    fi
}

# ── Config List ────────────────────────────────────────
CONFIG_DIRS=(
    "hypr"
    "waybar"
    "rofi"
    "swaync"
    "gtk-3.0"
    "gtk-4.0"
    "qt5ct"
    "qt6ct"
)

# ── Backup ─────────────────────────────────────────────
backup_configs() {
    log "Backing up existing configs to $BACKUP_DIR"

    if $DRY_RUN; then
        for dir in "${CONFIG_DIRS[@]}"; do
            if [ -d "$HOME/.config/$dir" ]; then
                info "[DRY-RUN] Would backup: ~/.config/$dir"
            fi
        done
        return
    fi

    mkdir -p "$BACKUP_DIR"
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ -d "$HOME/.config/$dir" ]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
            info "Backed up: ~/.config/$dir"
        fi
    done

    echo "$BACKUP_DIR" > "$HOME/.cache/hlrf_last_backup"
    log "Backup complete ✓"
}

# ── Install Configs ────────────────────────────────────
install_configs() {
    log "Installing HLRF configs..."

    for dir in "${CONFIG_DIRS[@]}"; do
        local src="$CONFIG_SRC/$dir"
        local dest="$HOME/.config/$dir"

        if [ ! -d "$src" ]; then
            warn "Source not found: $src — skipping"
            continue
        fi

        if $DRY_RUN; then
            info "[DRY-RUN] Would install: $src → $dest"
        else
            mkdir -p "$dest"
            cp -rf "$src"/* "$dest/"
            info "Installed: $dir"
        fi
    done

    # Copy wallpapers
    local wp_src="$SCRIPT_DIR/wallpapers"
    local wp_dest="$HOME/.config/hypr/wallpapers"
    if [ -d "$wp_src" ]; then
        if $DRY_RUN; then
            info "[DRY-RUN] Would copy wallpapers to $wp_dest"
        else
            mkdir -p "$wp_dest"
            cp -rn "$wp_src"/* "$wp_dest/" 2>/dev/null || true
            info "Copied wallpapers"
        fi
    fi

    # Make scripts executable
    if ! $DRY_RUN; then
        chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
        log "Made scripts executable ✓"
    fi

    log "Config installation complete ✓"
}

# ── Uninstall ──────────────────────────────────────────
uninstall() {
    log "Uninstalling HLRF..."

    local last_backup=""
    if [ -f "$HOME/.cache/hlrf_last_backup" ]; then
        last_backup="$(cat "$HOME/.cache/hlrf_last_backup")"
    fi

    if [ -z "$last_backup" ] || [ ! -d "$last_backup" ]; then
        error "No backup found. Cannot restore previous configs."
        warn "You can manually remove HLRF configs from ~/.config/"
        exit 1
    fi

    log "Restoring configs from: $last_backup"

    for dir in "${CONFIG_DIRS[@]}"; do
        if $DRY_RUN; then
            info "[DRY-RUN] Would restore: $last_backup/$dir → ~/.config/$dir"
        else
            if [ -d "$last_backup/$dir" ]; then
                rm -rf "$HOME/.config/$dir"
                cp -r "$last_backup/$dir" "$HOME/.config/$dir"
                info "Restored: $dir"
            else
                rm -rf "$HOME/.config/$dir"
                info "Removed: $dir (no backup existed)"
            fi
        fi
    done

    # Clean up cache files
    if ! $DRY_RUN; then
        rm -f "$HOME/.cache/hlrf_current_wallpaper"
        rm -f "$HOME/.cache/hlrf_nightlight"
        rm -f "$HOME/.cache/hlrf_gamemode"
        rm -f "$HOME/.cache/hlrf_screenrecord_pid"
    fi

    log "Uninstall complete ✓"
    info "Please restart Hyprland or reboot."
}

# ── Main ───────────────────────────────────────────────
main() {
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║   HyprLite Rice Framework — Installer   ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    if $DRY_RUN; then
        warn "DRY-RUN MODE — No changes will be made"
        echo ""
    fi

    if $UNINSTALL; then
        uninstall
        exit 0
    fi

    check_system
    install_dependencies
    backup_configs
    install_configs

    echo ""
    log "══════════════════════════════════════════"
    log " Installation complete! 🎉"
    log "══════════════════════════════════════════"
    echo ""
    info "Next steps:"
    echo "  1. Add wallpapers to ~/.config/hypr/wallpapers/"
    echo "  2. Log out and select Hyprland from your display manager"
    echo "  3. Or run: start-hyprland"
    echo ""
    info "Keybind cheat sheet:"
    echo "  Super + Space     → App Launcher"
    echo "  Super + Return    → Terminal (kitty)"
    echo "  Super + Q         → Close Window"
    echo "  Super + 1-0       → Workspaces"
    echo "  Super + X         → Power Menu"
    echo "  Super + S         → Scratchpad"
    echo "  Print             → Screenshot (area)"
    echo "  Shift + Print     → Screenshot (full)"
    echo "  Super + W         → Next Wallpaper"
    echo "  Super + N         → Night Light Toggle"
    echo "  Super + Delete    → Lock Screen"
    echo ""
}

main "$@"
