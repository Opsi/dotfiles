#!/bin/bash

action="$1"
# Change this to your preferred playerctl player prefix
pref="spotify"

if [ -z "$action" ]; then
  echo "Usage: $0 <play-pause|next|previous>"
  exit 1
fi

if playerctl -l | grep -q "$pref"; then
  playerctl -p "$pref" "$action"
else
  playerctl "$action"
fi
