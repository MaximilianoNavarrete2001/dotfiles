#!/usr/bin/env bash
set -eu

BAT="/sys/class/power_supply/BAT1"
battery_level=$(cat "$BAT/capacity")
battery_status=$(cat "$BAT/status")

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

LOW_ID=4444
HIGH_ID=4445

LOW_THRESHOLD=15
HIGH_THRESHOLD=95

STATE_FILE="$HOME/.local/share/battery_notify.state"
mkdir -p "$(dirname "$STATE_FILE")"

low_active=0
high_active=0

if [[ -f "$STATE_FILE" ]]; then
    source "$STATE_FILE"
fi

if [[ "$battery_status" == "Discharging" && $battery_level -le $LOW_THRESHOLD ]]; then
    if [[ "$low_active" != "1" ]]; then
        notify-send -u critical -r "$LOW_ID" -t 0 \
            "Low Battery" "Level: ${battery_level}%"
        low_active=1
    fi

elif [[ "$low_active" == "1" && ( "$battery_status" == "Charging" || "$battery_status" == "Full" ) ]]; then
    notify-send -u low -r "$LOW_ID" -t 20 " " " "
    low_active=0
fi

if [[ "$battery_status" == "Charging" && $battery_level -ge $HIGH_THRESHOLD ]]; then
    if [[ "$high_active" != "1" ]]; then
        notify-send -u normal -r "$HIGH_ID" -t 0 \
            "Battery almost full" "Level: ${battery_level}%"
        high_active=1
    fi

elif [[ "$high_active" == "1" && "$battery_status" != "Charging" ]]; then
    notify-send -u low -r "$HIGH_ID" -t 30 " " " "
    high_active=0
fi

{
    echo "low_active=$low_active"
    echo "high_active=$high_active"
} > "$STATE_FILE"

