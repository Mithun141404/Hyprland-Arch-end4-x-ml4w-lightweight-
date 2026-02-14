#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════╗
# ║  HyprLite — Screen Record Toggle                   ║
# ╚══════════════════════════════════════════════════════╝

RECORDINGS_DIR="$HOME/Videos/Recordings"
PIDFILE="$HOME/.cache/hlrf_screenrecord_pid"
mkdir -p "$RECORDINGS_DIR"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    # Stop recording
    kill "$(cat "$PIDFILE")"
    rm "$PIDFILE"
    notify-send -i "media-record" "Screen Recording" "Recording saved to $RECORDINGS_DIR" -t 3000
else
    # Start recording
    FILENAME="$RECORDINGS_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"

    # Area selection or full screen
    if [ "$1" = "area" ]; then
        GEOMETRY=$(slurp)
        [ -z "$GEOMETRY" ] && exit 1
        wf-recorder -g "$GEOMETRY" -f "$FILENAME" &
    else
        wf-recorder -f "$FILENAME" &
    fi

    echo $! > "$PIDFILE"
    notify-send -i "media-record" "Screen Recording" "Recording started..." -t 2000
fi
