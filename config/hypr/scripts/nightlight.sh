#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Night Light Toggle                     ║
# ╚══════════════════════════════════════════════════════╝

# Uses wlsunset for reliable night light (screen_shader was deprecated)

STATE_FILE="$HOME/.cache/hlrf_nightlight"

if [ -f "$STATE_FILE" ]; then
    # Disable night light
    pkill -x wlsunset 2>/dev/null
    rm "$STATE_FILE"
    notify-send -i "weather-clear-night" "Night Light" "Disabled" -t 1500
else
    # Enable night light — warm color temperature
    pkill -x wlsunset 2>/dev/null
    wlsunset -t 3500 -T 4500 &
    touch "$STATE_FILE"
    notify-send -i "weather-clear-night" "Night Light" "Enabled" -t 1500
fi
