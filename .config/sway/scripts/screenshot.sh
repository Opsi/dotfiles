#!/bin/bash

# Define a mapping for display names to internal modes
declare -A MODES
MODES["Region (Clipboard)"]="rect-clip"
MODES["Region (Swappy)"]="rect-swappy"

# Get Sway outputs and add options for each
SWAY_OUTPUTS=$(swaymsg -t get_outputs -r | jq -r '.[].name')
for OUTPUT in $SWAY_OUTPUTS; do
    MODES["Output: $OUTPUT (Clipboard)"]="output-clip-$OUTPUT"
    MODES["Output: $OUTPUT (Swappy)"]="output-swappy-$OUTPUT"
done

MODE="$1"

if [ -z "$MODE" ]; then
    # Generate Wofi input from display names
    WOFI_INPUT=$(printf "%s\n" "${!MODES[@]}")
    SELECTED_DISPLAY_NAME=$(echo -e "$WOFI_INPUT" | wofi --dmenu -p "Screenshot Mode:")

    if [ -z "$SELECTED_DISPLAY_NAME" ]; then
        exit 0 # User cancelled Wofi
    fi

    # Get the internal mode from the display name
    MODE="${MODES[$SELECTED_DISPLAY_NAME]}"
fi

# If MODE is still empty (e.g., direct call with unknown arg, or Wofi logic error)
if [ -z "$MODE" ]; then
    echo "Error: Invalid mode selected or provided."
    echo "Usage: $0 {rect-clip|rect-swappy|output-clip-<name>|output-swappy-<name>}"
    exit 1
fi

case "$MODE" in
  rect-clip)
    grim -g "$(slurp)" -t png - | wl-copy
    notify-send "Screenshot copied to clipboard"
    ;;
  rect-swappy)
    grim -g "$(slurp)" -t png - | swappy -f -
    ;;
  output-clip-*)
    # Extract output name
    OUTPUT_NAME="${MODE#output-clip-}"
    grim -o "$OUTPUT_NAME" -t png - | wl-copy
    notify-send "Screenshot of output $OUTPUT_NAME copied to clipboard"
    ;;
  output-swappy-*)
    # Extract output name
    OUTPUT_NAME="${MODE#output-swappy-}"
    grim -o "$OUTPUT_NAME" -t png - | swappy -f -
    notify-send "Screenshot of output $OUTPUT_NAME saved to swappy"
    ;;
  *)
    echo "Error: Unknown mode '$MODE'."
    echo "Usage: $0 {rect-clip|rect-swappy|output-clip-<name>|output-swappy-<name>}"
    exit 1
    ;;
esac
