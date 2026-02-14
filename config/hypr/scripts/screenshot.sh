#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Screenshot Script                      ║
# ╚══════════════════════════════════════════════════════╝

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"
FILENAME="$SCREENSHOTS_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$1" in
    area)
        grim -g "$(slurp -d)" "$FILENAME"
        ;;
    full)
        grim "$FILENAME"
        ;;
    window)
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
        ;;
    *)
        echo "Usage: $0 {area|full|window}"
        exit 1
        ;;
esac

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send -i "$FILENAME" "Screenshot Captured" "Saved to $FILENAME\nCopied to clipboard" -t 3000
fi
