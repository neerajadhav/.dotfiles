#!/bin/bash

grep -Po "(?<=file=).+" ~/.config/nitrogen/bg-saved.cfg | while read -r wallpaper; do
    # sh ~/.config/polybar/shades/scripts/pywal.sh  "$wallpaper"
    wal -i "$wallpaper"
done