#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Game Mode Toggle                       ║
# ╚══════════════════════════════════════════════════════╝

STATE_FILE="$HOME/.cache/hlrf_gamemode"

if [ -f "$STATE_FILE" ]; then
    # Disable game mode — restore animations & effects
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword general:gaps_in 4;\
        keyword general:gaps_out 8;\
        keyword general:border_size 2;\
        keyword decoration:rounding 10"
    rm "$STATE_FILE"
    notify-send -i "applications-games" "Game Mode" "Disabled — Effects restored" -t 2000
else
    # Enable game mode — disable everything for max performance
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    touch "$STATE_FILE"
    notify-send -i "applications-games" "Game Mode" "Enabled — Max performance" -t 2000
fi
