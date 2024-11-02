#!/bin/bash

# Check for command-line argument
if [[ "$1" == "--up" ]]; then
    adjustment="+5%"
elif [[ "$1" == "--down" ]]; then
    adjustment="-5%"
else
    echo "Usage: $0 --up or --down"
    exit 1
fi

# Gather all active sink input IDs and their current volume levels
sink_input_ids=($(pactl list sink-inputs short | awk '{print $1}'))
volumes=()

# Loop through each sink input to retrieve its current volume
for id in "${sink_input_ids[@]}"; do
    volume=$(pactl list sink-inputs | grep -A 15 "Sink Input #$id" | grep "Volume:" | head -n 1 | awk '{print $5}' | tr -d '%')
    volumes+=("$volume")
done

# Find the minimum volume level among all sink inputs
if [ "${#volumes[@]}" -gt 0 ]; then
    min_volume=$(printf "%s\n" "${volumes[@]}" | sort -n | head -n 1)
else
    notify-send "Volume" "No active audio stream found."
    exit 1
fi

# Calculate the target volume based on the action
if [[ "$1" == "--up" ]]; then
    target_volume=$((min_volume + 5))
else
    target_volume=$((min_volume - 5))
fi

# Ensure the target volume stays within 0-100%
target_volume=$(( target_volume < 0 ? 0 : ( target_volume > 100 ? 100 : target_volume ) ))

# Round to the nearest 5%
remainder=$(( target_volume % 5 ))
if [ "$remainder" -ge 3 ]; then
    target_volume=$(( target_volume + (5 - remainder) ))
else
    target_volume=$(( target_volume - remainder ))
fi

# Apply the target volume to all sink inputs
for id in "${sink_input_ids[@]}"; do
    pactl set-sink-input-volume "$id" "${target_volume}%"
done

# Notify with the new volume level
notify-send "Volume" "All streams set to: ${target_volume}%" -t 1500

# Convert target_volume percentage to paplay's volume scale (0-65536)
volume_scale=$(( target_volume * 65536 / 100 ))

# Play a system sound to signal the command execution
paplay --volume=$volume_scale /usr/share/sounds/freedesktop/stereo/message.oga