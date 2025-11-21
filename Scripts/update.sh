#!/usr/bin/env bash

set -eu 

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

SUCCESS_ID=4445
ERROR_ID=4444
CURRENT_STEP="Start"

on_error() {
    local line="$1"
    local code="$2"

    notify-send -u critical -r "$ERROR_ID" "🛑 Update Failed" \"
"Step: $CURRENT_STEP
Line: $line
Exit code: $code"

    exit "$code"
}

trap 'on_error $LINENO $?' ERR

CURRENT_STEP="Updating official repositories (pacman)"
sudo pacman -Syu --noconfirm

CURRENT_STEP="Checking orphan packages"
orphans=$(pacman -Qdtq || true)

CURRENT_STEP="Removing orphan packages"
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns --noconfirm $orphans
fi

CURRENT_STEP="Cleaning pacman cache"
sudo paccache -r

CURRENT_STEP="Updating AUR packages (yay)"
if command -v yay >/dev/null 2>&1; then
    yay -Syu --noconfirm
fi

trap - ERR

notify-send -u normal -t 600000 -r "$SUCCESS_ID" \
    "✅ System Updated" \
    "All update steps completed successfully."
