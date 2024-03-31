#!/bin/sh -e

# Function to get the value of 'file' attribute from bg-saved.cfg
get_file_value() {
    config_file=~/.config/nitrogen/bg-saved.cfg
    if [ -f "$config_file" ]; then
        while IFS='=' read -r key value; do
            key=$(echo "$key" | tr -d '[:space:]')
            value=$(echo "$value" | tr -d '[:space:]')
            if [ "$key" = "file" ]; then
                echo "$value"
                break
            fi
        done < "$config_file"
    else
        echo "Error: Configuration file '$config_file' not found."
    fi
}

# Convert the image to PNG format and apply blur
converted_file="/tmp/converted_image.png"
convert "$(get_file_value)" -blur 0x8 "$converted_file"

# Lock screen displaying this image.
# xss-lock --transfer-sleep-lock -- i3lock --nofork -i "$converted_file"
i3lock -i "$converted_file"

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
