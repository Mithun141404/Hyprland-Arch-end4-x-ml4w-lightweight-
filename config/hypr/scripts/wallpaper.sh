#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Wallpaper Script (Swww)                ║
# ╚══════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CACHE_FILE="$HOME/.cache/hlrf_current_wallpaper"

# Create dirs if needed
mkdir -p "$WALLPAPER_DIR" "$(dirname "$CACHE_FILE")"

set_wallpaper() {
    local img="$1"
    swww img "$img" \
        --transition-type fade \
        --transition-duration 1 \
        --transition-fps 30
    echo "$img" > "$CACHE_FILE"
}

case "$1" in
    init)
        # Set last used wallpaper or first available
        if [ -f "$CACHE_FILE" ] && [ -f "$(cat "$CACHE_FILE")" ]; then
            set_wallpaper "$(cat "$CACHE_FILE")"
        else
            first=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | head -1)
            [ -n "$first" ] && set_wallpaper "$first"
        fi
        ;;
    next)
        # Cycle to next wallpaper
        wallpapers=($(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | sort))
        count=${#wallpapers[@]}
        [ "$count" -eq 0 ] && notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR" && exit 1

        current=""
        [ -f "$CACHE_FILE" ] && current="$(cat "$CACHE_FILE")"

        next_idx=0
        for i in "${!wallpapers[@]}"; do
            if [ "${wallpapers[$i]}" = "$current" ]; then
                next_idx=$(( (i + 1) % count ))
                break
            fi
        done

        set_wallpaper "${wallpapers[$next_idx]}"
        notify-send -t 2000 "Wallpaper" "Changed to $(basename "${wallpapers[$next_idx]}")"
        ;;
    set)
        # Set specific wallpaper
        [ -z "$2" ] && echo "Usage: $0 set <path>" && exit 1
        [ ! -f "$2" ] && echo "File not found: $2" && exit 1
        set_wallpaper "$2"
        ;;
    *)
        echo "Usage: $0 {init|next|set <path>}"
        exit 1
        ;;
esac
