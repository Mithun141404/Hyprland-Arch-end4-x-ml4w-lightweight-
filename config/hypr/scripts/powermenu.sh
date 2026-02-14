#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Power Menu Script                      ║
# ╚══════════════════════════════════════════════════════╝

options="  Lock\n  Logout\n  Suspend\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu \
    -theme ~/.config/rofi/powermenu.rasi \
    -p "Power" \
    -selected-row 0)

case "$chosen" in
    *Lock)
        hyprlock
        ;;
    *Logout)
        hyprctl dispatch exit
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
esac
