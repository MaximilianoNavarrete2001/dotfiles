#!/usr/bin/env bash
set -euo pipefail

# --- Menu minimalista solo con Firefox y Thunar ---
opcion="$(printf "ChatGPT\nWhatsApp\nYouTube\nFirefox\nThunar\nTyping\nUdemy\nMastermind" | rofi -dmenu -p 'Abrir' \
    -theme-str 'window { width: 24%; padding: 8px; }' \
    -theme-str 'listview { lines: 5; fixed-height: true; }')"

# --- Switch en bash ---
case "$opcion" in
    Firefox)
        nohup firefox >/dev/null 2>&1 &
        ;;
    Thunar)
        nohup thunar >/dev/null 2>&1 &
        ;;
    ChatGPT)
        nohup firefox --new-tab "https://chatgpt.com" >/dev/null 2>&1 &
        ;;
    WhatsApp)
        nohup firefox --new-tab "https://web.whatsapp.com" >/dev/null 2>&1 &
        ;;
    Typing)
        nohup firefox --new-tab "https://www.edclub.com/signin" >/dev/null 2>&1 &
        ;;
    Udemy)
        nohup firefox --new-tab "https://www.udemy.com" >/dev/null 2>&1 &
        ;;
    Mastermind)
        nohup firefox --new-tab "https://mastermind.ac/inicio" >/dev/null 2>&1 &
        ;;
    YouTube)
        nohup firefox --new-tab "https://www.youtube.com" >/dev/null 2>&1 &
        ;;
    *)
        exit 0
        ;;
esac

