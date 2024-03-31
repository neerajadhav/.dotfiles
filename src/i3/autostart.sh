#!/usr/bin/env bash

# Set wal colors and lockscreen
grep -Po "(?<=file=).+" ~/.config/nitrogen/bg-saved.cfg | while read -r wallpaper; do
    # sh ~/.config/polybar/shades/scripts/pywal.sh  "$wallpaper"
    wal -i "$wallpaper"
    betterlockscreen -u "$wallpaper"
done

autotiling -l 2 &