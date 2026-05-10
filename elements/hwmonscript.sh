#!/bin/bash

# Loop through each hwmon directory
for hwmon in /sys/class/hwmon/hwmon*; do
    # Get the sensor name
    sensor_name=$(cat "$hwmon/name" 2>/dev/null)

    # Check if the sensor name corresponds to a CPU
    if [[ $sensor_name == *"CPU"* || $sensor_name == *"core"* || $sensor_name == *"temp"* ]]; then
        # Loop through temperature files for this hwmon
        for temp_file in "$hwmon"/temp*_input; do
            if [ -e "$temp_file" ]; then
                # Read the temperature value
                temp_value=$(cat "$temp_file")

                # Convert to Celsius if necessary
                temp_celsius=$(echo "scale=2; $temp_value / 1000" | bc)

                # Output the sensor name and temperature
                echo "$sensor_name: $temp_celsius °C"
            fi
        done
    fi
done


