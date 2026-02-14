#!/bin/bash
set -e

# Backup current configs
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.config-backup-$TIMESTAMP"
mkdir -p "$BACKUP_DIR"
echo "Backup directory created at $BACKUP_DIR"

CONFIG_DIRS=("hypr" "waybar" "rofi" "swaync" "gtk-3.0" "gtk-4.0" "qt5ct" "qt6ct")
REPO_CONFIG_DIR="/home/legend/.gemini/antigravity/scratch/hypr-lite/config"

for dir in "${CONFIG_DIRS[@]}"; do
    TARGET="$HOME/.config/$dir"
    
    if [ -L "$TARGET" ]; then
        echo "Updating symlink for $dir..."
        rm "$TARGET"
    elif [ -d "$TARGET" ]; then
        echo "Backing up existing directory $dir..."
        mv "$TARGET" "$BACKUP_DIR/"
    else
        echo "No existing config for $dir, creating new symlink..."
    fi

    ln -s "$REPO_CONFIG_DIR/$dir" "$TARGET"
    echo "Symlinked $dir -> $REPO_CONFIG_DIR/$dir"
done

echo "Done! restart your session or reload Hyprland to see changes."
