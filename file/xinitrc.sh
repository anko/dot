# Remap the keyboard
setxkbmap -layout gb
[[ -s ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Hide mouse
unclutter -root -grab -idle 2 -reset &

# Enable window transparency
compton &

# Enable desktop notifications
dunst &

# Enable Japanese input
ibus-daemon --xim &

# Reduce eye strain at nighttime
redshift

# Lower delay before key repeat
xset r rate 350 40

# Show normal cursor on root window
xsetroot -cursor_name left_ptr

# Restore wallpaper
feh --bg-fill /home/an/img/wal/current

# Log keypresses
keylog-10-mins >> ~/data/keylog10 &

# Start WM
exec i3
