#!/usr/bin/env bash

# Ikke start ny hvis en Screensaver allerede kjører
if pgrep -f "alacritty --class Screensaver" >/dev/null; then
  exit 0
fi

alacritty --class=Screensaver -e "$HOME/.config/hypr/scripts/screensaver.sh"
