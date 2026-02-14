#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Brightness Control Script              ║
# ╚══════════════════════════════════════════════════════╝

STEP=5

get_brightness() {
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

send_notification() {
    local brightness=$(get_brightness)
    local icon

    if [ "$brightness" -ge 70 ]; then
        icon="display-brightness-high"
    elif [ "$brightness" -ge 30 ]; then
        icon="display-brightness-medium"
    else
        icon="display-brightness-low"
    fi

    notify-send -h int:value:"$brightness" -h string:x-canonical-private-synchronous:brightness \
        -i "$icon" "Brightness" "${brightness}%" -t 1500
}

case "$1" in
    up)
        brightnessctl set "${STEP}%+" -q
        send_notification
        ;;
    down)
        brightnessctl set "${STEP}%-" -q
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac
