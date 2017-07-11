#!/usr/bin/env zsh

# Generates configuration files in the expected places.  Supports arbitrary
# commands, but typically you just want symlinks.
#
# Accepts '--dry-run' flag which makes it not actually do anything, just show
# what it would have done.

# Allow '~' to be expanded
setopt GLOB_SUBST

# Parse flags
zparseopts -A opts -- -dry-run
DRY_RUN=${+opts[--dry-run]}
if (( $DRY_RUN )); then
    print -P "%F{33}Dry-run mode!%f"
    print -P "%F{33}-------------%f"
    print -P "%F{33}No changes will be made.%f"
    print -P "%F{33}Commands that would be run will be printed instead.%f"
fi

# Some shortcuts, for prettiness
function exists () { [[ -e $1 ]] }
function link () { echo "ln -sf $PWD/file/$1 \$TARGET" }

# This acts as the "domain-specific language" to specify how files should be
# generated.  Replaces any occurrences of '$TARGET' in the command string with
# the file path given as the first argument.  Implicitly creates all
# directories without being asked.
function gen () {
    TARGET=$1            # Location where the config file should go
    GENERATOR_COMMAND=$2 # Command string that will generate it
    if exists "$TARGET"; then
        print -P "%F{green}Exists%f: $TARGET"
    else
        print -P "%F{yellow}Installing%f: $TARGET"
        if (( $DRY_RUN )); then
            print -P "%F{33}Would run%f $GENERATOR_COMMAND"
        else
            echo "mkdir --parents $(dirname $TARGET)" \
                | tee >(source /dev/stdin)
            echo "$GENERATOR_COMMAND" \
                | sed "s:\$TARGET:$TARGET:" \
                | tee >(source /dev/stdin)
        fi
    fi
}

# Construction specifications

# vim
gen '~/.config/nvim/init.vim' "$(link nvim/init.vim)"
gen '~/.vimrc' 'ln -s ~/.config/nvim/init.vim $TARGET'
# Download plug.vim if necessary. Follow up with a :PlugInstall.
gen '~/.config/nvim/autoload/plug.vim' \
    'curl -fLo $TARGET --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && nvim -c PlugInstall -c qall'

# zsh
gen '~/.zshrc'    "$(link zsh/init.zsh)"
gen '~/.zprofile' "$(link zsh/profile.zsh)"

# X11
gen '~/.xinitrc'   "$(link xinitrc.sh)"
gen '~/.Xmodmap'   "$(link xmodmap)"
gen '~/.Xcompose'  "$(link xcompose)"

gen '~/.config/zathura/zathurarc'     "$(link zathurarc)"          # zathura
gen '~/.config/compton.conf'          "$(link compton.conf)"       # compton
gen '~/.config/user-dirs.dirs'        "$(link xdg-user-dirs.dirs)" # XDG dirs
gen '~/.config/sxiv/exec/key-handler' "$(link sxiv-key-handler)"   # sxiv
gen '~/.asoundrc'                     "$(link asoundrc)"           # ALSA
gen '~/.tmux.conf'                    "$(link tmux.conf)"          # tmux
gen '~/.gitconfig'                    "$(link gitconfig)"          # git
gen '~/.config/dunst/dunstrc'         "$(link dunstrc)"            # dunst
gen '~/.config/i3'                    "$(link i3)"                 # i3
gen '~/.config/mpv/input.conf'        "$(link mpv-input.conf)"     # mpv
