# Run a program and raise a notification saying so
notify-send --urgency low "r:$1"
exec sh -c "$1"
