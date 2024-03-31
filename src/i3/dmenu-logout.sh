#!/bin/bash

# Set environment
export I3_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/i3"

# Import the colors
. "${HOME}/.cache/wal/colors.sh"

# Function to kill programs
killprogs() {
    # Kill panel
    pkill -x panel
    # Kill Redshift
    pkill -x redshift
}

# Restart function
restart() {
    # Kill programs
    killprogs
    # Restart i3
    i3-msg restart
}

# Logout function
logout() {
    # Kill programs
    killprogs
    # Exit i3
    i3-msg exit
}

# Load dmenu config
[ -f "$HOME/.dmenurc" ] && . "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="logout
poweroff
reboot
hibernate
suspend"

# Open menu
selection=$(printf '%s' "$items" | $DMENU -i -l 10 -p 'i3wm' -fn 'Ubuntu Mono:bold:pixelsize=15' -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15")

case $selection in
    logout)
        logout
        ;;
    poweroff)
        logout
        systemctl poweroff
        ;;
    reboot)
        logout
        systemctl reboot
        ;;
    hibernate)
        systemctl hibernate
        ;;
    suspend)
        systemctl suspend
        ;;
esac

exit
