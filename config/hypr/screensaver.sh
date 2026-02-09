#!/usr/bin/env bash

# sørg for at tte fra pipx funker
export PATH="$HOME/.local/bin:$PATH"

screensaver_in_focus() {
  hyprctl activewindow -j | jq -e '.class == "Screensaver"' >/dev/null 2>&1
}

cleanup() {
  hyprctl keyword cursor:invisible false
  pkill -x tte 2>/dev/null
  exit 0
}

trap cleanup SIGINT SIGTERM SIGHUP SIGQUIT

hyprctl keyword cursor:invisible true &>/dev/null

# bruk full sti hvis nødvendig
TTE_BIN="${TTE_BIN:-$HOME/.local/bin/tte}"

while true; do
  effect=$("$TTE_BIN" 2>&1 | grep -oP '{\K[^}]+' | tr ',' ' ' | tr ' ' '\n' |
    sed -n '/^beams$/,$p' | sort -u | shuf -n1)

  "$TTE_BIN" -i "$HOME/.config/zrgst/screensaver.txt" \
    --frame-rate 240 \
    --canvas-width 0 \
    --canvas-height "$(($(tput lines) - 2))" \
    --anchor-canvas c \
    --anchor-text c \
    "$effect" &

  while pgrep -x tte >/dev/null; do
    # tastetrykk eller mister fokus → avslutt
    if read -n 1 -t 3 || ! screensaver_in_focus; then
      cleanup
    fi
  done
done
