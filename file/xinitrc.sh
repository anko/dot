(if [ "$(cat /sys/class/drm/card0-DP-2/status)" = connected ]; then
    /usr/bin/xrandr --output eDP-1 --off
fi) &

setxkbmap -layout us                    # us layout
xmodmap ~/.Xmodmap                      # key remaps
xsetroot -cursor_name left_ptr          # root window normal cursor
xset r rate 350 40                      # lower key repeat delay

unclutter -root -grab -idle 2 -reset &  # hide mouse when idle
compton &                               # window transparency
dunst &                                 # desktop notifications
ibus-daemon --xim &                     # Japanese input
feh --bg-fill ~/img/wal/current &       # restore saved wallpaper
keylog-10-mins >> ~/data/keylog10 &     # log keypresses
firefox-fullscreen-dpms-inhibit &       # workaround timeout during videos

exec i3
