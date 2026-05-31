#!/bin/bash

WIRED="enp3s0f3u1u1"
WIRELESS="wlan0"
STATE_FILE="/tmp/polybar_network_mode"

# Initialize state file
if [ ! -f "$STATE_FILE" ]; then
    echo "auto" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

# Handle click to toggle
if [ "$1" = "toggle" ]; then
    if [ "$MODE" = "auto" ] || [ "$MODE" = "wired" ]; then
        echo "wireless" > "$STATE_FILE"
    else
        echo "wired" > "$STATE_FILE"
    fi
    exit 0
fi

show_wired() {
    if ip link show "$WIRED" | grep -q "state UP\|UNKNOWN"; then
        IP=$(ip addr show "$WIRED" | grep "inet " | awk '{print $2}' | cut -d/ -f1)
        echo "󰑩 ${IP:-No IP}"
    else
        echo "󱖣 Unplugged"
    fi
}

show_wireless() {
    if ip link show "$WIRELESS" | grep -q "state UP\|UNKNOWN"; then
        SSID=$(iwgetid -r 2>/dev/null)
        if [ -n "$SSID" ]; then
            SIGNAL=$(awk 'NR==3{print int($3*10/7)}' /proc/net/wireless 2>/dev/null)
            echo "󰤨 $SSID"
        else
            echo "󰤭 Not Connected"
        fi
    else
        echo "󰤭 Offline"
    fi
}

case "$MODE" in
    wired)    show_wired ;;
    wireless) show_wireless ;;
    auto)
        # Auto: prefer wired if connected
        if ip link show "$WIRED" | grep -q "LOWER_UP"; then
            show_wired
        else
            show_wireless
        fi
        ;;
esac