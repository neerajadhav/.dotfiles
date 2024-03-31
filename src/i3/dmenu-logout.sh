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
items="Logout
Poweroff
Reboot
Hibernate
Suspend"

# Open menu
selection=$(printf '%s' "$items" | $DMENU -i -l 10 -p 'Power Menu' -fn 'Ubuntu Mono:bold:pixelsize=15' -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15")

case $selection in
    Logout)
        logout
        ;;
    Poweroff)
        logout
        systemctl poweroff
        ;;
    Reboot)
        logout
        systemctl reboot
        ;;
    Hibernate)
        systemctl hibernate
        ;;
    Suspend)
        systemctl suspend
        ;;
esac

exit
