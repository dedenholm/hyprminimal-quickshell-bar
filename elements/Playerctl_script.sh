#!/bin/bash	

# Capture the output of playerctl metadata; redirect both stdout and stderr
metadataoutput=$(playerctl metadata --format "metadata: {{ (artist) }} -- {{ (title) }}" 2>&1)
statusoutput=$(playerctl metadata --format "status: {{(status)}}" 2>&1)
playeroutput=$(playerctl metadata --format "player: {{(playerName)}} {{(volume)}}" 2>&1)
# Check if output contains the specific error message or is empty
if [[ "$metadataoutput" == *"No player could handle this command"* || -z "$metadataoutput" ]]; then
    echo "off"
else
    echo "$metadataoutput"
    echo "$statusoutput"
    echo "$playeroutput"
fi

