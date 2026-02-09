#!/usr/bin/env bash
set -euo pipefail

# Base directory for screenshots
BASE_DIR="$HOME/Pictures"
DIR="$BASE_DIR/Screenshots"
mkdir -p "$DIR"

timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"

mode="${1-}"

case "$mode" in
	area)
		# Area -> file -> Clipboard
		file="$DIR/area_${timestamp}.png"
		grim -g "$(slurp)" - | tee "$file" | wl-copy
		;;
	area-edit|area-annotate)
		# Area -> Swappy editor (You save manually)
		grim -g "$(slurp)" - | swappy -f -
		;;
	
	window)
		# Active Window -> File + clipboard
		file="$DIR/window_${timestamp}.png"
		grimblast save active "$file"
		wl-copy < "$file"
		;;
	
	full|output)
		# Focused output -> File + clipboard
		file="$DIR/full_${timestamp}.png"
		grimblast save output "$file"
		;;
	
	*)
		echo "Usage: $0 {area|area-edit|window|full}" >&2
		exit 1
		;;
esac
