#!/bin/bash

BACKLIGHT="/sys/class/backlight/amdgpu_bl1"

current=$(cat "$BACKLIGHT/brightness")
max=$(cat "$BACKLIGHT/max_brightness")
percent=$(( current * 100 / max ))

icon=""   

low="#928374"    
mid="#fbf1c7"
high="#F0C674"  

if   [ "$percent" -lt 30 ]; then
    color="$low"
elif [ "$percent" -lt 70 ]; then
    color="$mid"
else
    color="$high"
fi

echo "%{F$color}$icon%{F-} $percent%"
