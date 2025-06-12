#!/bin/bash

MODE="$1"

case "$MODE" in
  rect-clip)
    grim -g "$(slurp)" -t png - | wl-copy
    notify-send "Screenshot copied to clipboard"
    ;;
  rect-swappy)
    grim -g "$(slurp)" -t png - | swappy -f -
    ;;
  *)
    echo "Usage: $0 {rect-clip|rect-swappy}"
    exit 1
    ;;
esac


