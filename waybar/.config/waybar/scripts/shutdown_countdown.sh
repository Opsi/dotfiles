#!/bin/bash

STATE_FILE="/tmp/waybar_shutdown_state"
COUNTDOWN=10

if [[ "$1" == "abort" ]]; then
  pkill -f "shutdown_countdown.sh run"
  echo "aborted" >"$STATE_FILE"
  exit 0
fi

if [[ "$1" == "run" ]]; then
  for ((i = COUNTDOWN; i > 0; i--)); do
    echo "$i" >"$STATE_FILE"
    sleep 1
  done
  systemctl poweroff
  exit 0
fi

# Default: print state
if [[ -f "$STATE_FILE" ]]; then
  cat "$STATE_FILE"
else
  echo "nuke"
fi
