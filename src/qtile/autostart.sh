#!/bin/bash

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    $@&
  fi
}

# Set your native resolution IF it does not exist in xrandr
# More info in the script

# Check if running in a Virtual Machine and set appropriate screen resolution
if [[ $(systemd-detect-virt) = "none" ]]; then
    echo "Not running in a Virtual Machine";
    if xrandr | grep "1366x768"; then
        xrandr -s 1366x768 || echo "Cannot set 1366x768 resolution.";
    elif xrandr | grep "1920x1080"; then
        xrandr -s 1920x1080 || echo "Cannot set 1920x1080 resolution.";
    else
        echo "Could not set a resolution."
    fi
fi

# Change your keyboard layout if needed
keybLayout=$(setxkbmap -v | awk -F "+" '/symbols/ {print $2}')
if [ $keybLayout = "be" ]; then
  cp $HOME/.config/qtile/config-azerty.py $HOME/.config/qtile/config.py
fi

# Autostart programs
run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop &
feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
run conky -c $HOME/.config/qtile/scripts/system-overview &
run sxhkd -c ~/.config/qtile/sxhkd/sxhkdrc &
# run variety &
run nitrogen --restore &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
numlockx on &
blueberry-tray &
picom --config $HOME/.config/qtile/scripts/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
run volumeicon &
# Uncomment other applications as needed
# run discord &
# run nitrogen --restore &
# run caffeine -a &
# run vivaldi-stable &
# run firefox &
# run thunar &
# run dropbox &
# run insync start &
# run spotify &
# run atom &
# run telegram-desktop &

# Check screen resolution and set appropriate Conky style
resolutionHeight=$(xrandr | grep "primary" | awk '{print $4}' | awk -F "+" '{print $1}' | awk -F 'x' '{print $2}')
if [[ $resolutionHeight -ge 1080 ]]; then
    killall conky || echo "Conky not running."
    sleep 2
    conky -c "$HOME"/.config/conky/qtile/01/"$COLORSCHEME".conf || echo "Couldn't start conky."
elif [[ $resolutionHeight -lt 1080 ]]; then
    killall conky || echo "Conky not running."
    sleep 2
    conky -c "$HOME"/.config/conky/qtile/02/"$COLORSCHEME".conf || echo "Couldn't start conky."
else
    killall conky || echo "Conky not running."
    sleep 2
    conky -c "$HOME"/.config/conky/qtile/02/"$COLORSCHEME".conf || echo "Couldn't start conky."
fi
