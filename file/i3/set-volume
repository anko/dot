#/bin/bash
# Change the volume, and send a 'kick' to a socket, which other stuff (e.g.
# statusline) can be listening to.
case $1 in
    up)
        amixer set SoftMaster 3%+ unmute && \
        echo -n update | socat - UNIX-CONNECT:/tmp/volumechange.sock;;
    down)
        amixer set SoftMaster 3%- unmute && \
        echo -n update | socat - UNIX-CONNECT:/tmp/volumechange.sock;;
    zero)
        amixer set SoftMaster 0 mute && \
        echo -n update | socat - UNIX-CONNECT:/tmp/volumechange.sock;;
esac
