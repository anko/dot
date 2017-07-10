#/bin/bash
case $1 in
    up)   xbacklight -inc 5% ;;
    down) xbacklight -dec 5% ;;
esac
