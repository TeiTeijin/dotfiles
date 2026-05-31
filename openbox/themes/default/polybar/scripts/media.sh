#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)
TITLE=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)

if [ "$STATUS" = "Playing" ]; then
    echo "󰐊 $TITLE"
elif [ "$STATUS" = "Paused" ]; then
    echo "󰏤 $TITLE"
fi