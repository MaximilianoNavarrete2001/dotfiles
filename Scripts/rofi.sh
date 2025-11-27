#!/usr/bin/env bash
set -euo pipefail

opcion="$(printf "Vim\nChatGPT\nWhatsApp\nYouTube\nGithub\nFirefox\nThunar\nTyping\nUdemy\nMastermind\nNetflix\nCrunchyroll" | rofi -dmenu -p 'Abrir' \
    -theme-str 'window { width: 24%; padding: 8px; }' \
    -theme-str 'listview { lines: 5; fixed-height: true; }')"

case "$opcion" in
    Netflix)
        nohup firefox --new-tab "https://www.netflix.com/browse"  >/dev/null 2>&1 &
        ;;
    Crunchyroll)
        nohup firefox --new-tab "https://www.crunchyroll.com/es/discover" >/dev/null 2>&1 &
        ;;
    Github)
        nohup firefox --new-tab "https://github.com/MaximilianoNavarrete2001"
        ;;
    Vim)
        nohup kitty -e vim >/dev/null 2>&1 &
        ;;
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

