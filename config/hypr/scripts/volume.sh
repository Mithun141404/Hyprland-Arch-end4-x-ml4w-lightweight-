#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Volume Control Script                  ║
# ╚══════════════════════════════════════════════════════╝

STEP=5

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}'
}

get_mute() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "yes" || echo "no"
}

send_notification() {
    local vol=$(get_volume)
    local muted=$(get_mute)
    local icon

    if [ "$muted" = "yes" ]; then
        icon="audio-volume-muted"
    elif [ "$vol" -ge 70 ]; then
        icon="audio-volume-high"
    elif [ "$vol" -ge 30 ]; then
        icon="audio-volume-medium"
    else
        icon="audio-volume-low"
    fi

    notify-send -h int:value:"$vol" -h string:x-canonical-private-synchronous:volume \
        -i "$icon" "Volume" "${vol}%" -t 1500
}

case "$1" in
    up)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        send_notification
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        send_notification
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac
