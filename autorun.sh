#!/usr/bin/env sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

exec >~/.cache/awesome/autorun.log 2>&1

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export _JAVA_AWT_WM_NONREPARENTING=1
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"

wmname LG3D
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option ctrl:nocaps
setxkbmap us
xrdb ~/.Xresources
xset -dpms
xset s off
xsetroot -cursor_name left_ptr
xset fp rehash
xss-lock --transfer-sleep-lock -- /home/elken/bin/lock

run nm-applet
run picom -b --experimental-backends --dbus
run kdeconnect-indicator
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Ensure the correct screen is loaded when restarting
if test -f /tmp/awesome-focused; then
    printf 'require("awful").screen.focus(%d)' $(cat /tmp/awesome-focused | head -n 1) | awesome-client
fi
