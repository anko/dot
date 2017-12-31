CONFIG_FILE="${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs"
[[ -f $CONFIG_FILE ]] && source $CONFIG_FILE

# Prepend to $PATH for convenience
PATH="$HOME/dot/script:$HOME/bin:$HOME/.npm-global/bin:$PATH"

startx
