#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Scratchpad Toggle                      ║
# ╚══════════════════════════════════════════════════════╝

# Launch a scratchpad terminal if none exists, otherwise toggle visibility
if ! hyprctl clients -j | jq -e '.[] | select(.class == "scratchpad")' > /dev/null 2>&1; then
    kitty --class scratchpad &
else
    hyprctl dispatch togglespecialworkspace scratchpad
fi
