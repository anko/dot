bindkey -v

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

export TERM=xterm-256color
export EDITOR=nvim
export BROWSER=chromium

setopt NO_BEEP        # Don't use system bell
setopt AUTO_CD        # Automatically cd to typed directories
setopt AUTO_PUSHD     # Automatically push directories onto directory stack
setopt AUTO_CONTINUE  # Automatically continue disowned processes
setopt EXTENDED_GLOB  # More globs
setopt NOTIFY         # Report on background job status immediately
setopt HIST_IGNORE_SPACE  # Don't save commands that start with a space
setopt HIST_NO_STORE      # Don't store history commands in history
setopt HIST_IGNORE_DUPS   # Ignore duplicates in history
setopt INC_APPEND_HISTORY # Write history immediately, rather than on exit

function command_not_found_handler() {
    print -P "%F{001}Missing command %F{009}$1%f";
    exit 127
}

autoload -Uz compinit
compinit
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select # Show matches in menu when tabbing through

#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

make_prompt() {

    local COLOUR_MAIN=023
    local COLOUR_GIT_ROOT=243
    local COLOUR_GIT_ROOT_BASENAME=015
    local COLOUR_BASENAME=051

    # cd to the given directory so we can use zsh's prompt expansion (print -P)
    # with %~ expanded relative to it.
    print_at() {
        ( cd $2 ; print -P $1 )
    }

    # Given a directory path, a last-segment highlight colour, and a path to
    # trim off the front, construct a string with appropriate PROMPT expansions
    # that represents that path (in COLOUR_MAIN) followed by the basename (in
    # the given colour), but with the given TRIM directory path removed from
    # the front of it where the two are identical.
    #
    # The trim path is intended for when a prompt calls make_path twice,
    # because it wants to colourise a directory in the middle of the directory
    # path.
    make_path() {
        local DIR_PATH="$1"
        local COLOUR="$2"
        local TRIM="$3"

        local BEFORE=""
        local AFTER=""

        if [[ $DIR_PATH = / ]]; then
            BEFORE=""
            AFTER="/"
        elif [[ "$DIR_PATH" = "$HOME" ]]; then
            BEFORE=""
            AFTER="~"
        else
            BEFORE=$(print_at '%~' "$DIR_PATH")
            BEFORE=$(print_at "${BEFORE%/*}/" "$DIR_PATH")
            AFTER=$(print_at '%1~' "$DIR_PATH")
            if [[ "$BEFORE" = / ]]; then
                BEFORE="/"
                AFTER=$(echo "$AFTER" | tail -c+2)
            fi
            if [[ -d "$TRIM" ]]; then # if given base path to trim by
                TRIM=$(print_at '%~' "$TRIM")
                BEFORE=${"$(echo "$BEFORE")"#"$(echo "$TRIM")"}
            else
            fi
        fi
        echo "%F{$COLOUR_MAIN}$BEFORE%f%F{$COLOUR}$AFTER%f"
    }

    # Add a status indicator to the end, and indicators to the start for
    # superuser shells and remote shells.
    assemble_final_prompt() {
        PROMPT_HEAD="%F{yellow}%M%f:"
        case "$HOST" in
            "39")
                PROMPT_HEAD=""
                ;;
        esac
        echo "%(!.%F{red}#%f .)$PROMPT_HEAD%F{$COLOUR_MAIN}$1%f%(?.. %F{red}%?%f)"
    }

    if [[ -d $(git rev-parse --show-toplevel 2>/dev/null) ]]; then
        # We're in a git repo.
        BASE="$(git rev-parse --show-toplevel)"
        if [[ $PWD = $(git rev-parse --show-toplevel) ]]; then
            # We're in the repository root.
            # Just show the root coloured.
            echo "$(assemble_final_prompt "$(make_path $PWD $COLOUR_GIT_ROOT_BASENAME)")"
        else
            # We're somewhere below the repository root.
            # Show the root coloured, and the path after it as normal.
            PATH_TO_ROOT=$(make_path "$BASE" "$COLOUR_GIT_ROOT")
            PATH_FROM_ROOT=$(make_path "$PWD" "$COLOUR_BASENAME" "$BASE")
            echo "$(assemble_final_prompt "$PATH_TO_ROOT$PATH_FROM_ROOT")"
        fi
    else
        # Basic case.
        # Show the current path, coloured.
        echo "$(assemble_final_prompt "$(make_path $PWD $COLOUR_BASENAME)")"
    fi
}
PROMPT=$'$(make_prompt) '

pwd-to-clip() {
    pwd | xclip -selection clipboard
}
cd-to-clip() {
    cd `xclip -o -selection clipboard`
    zle reset-prompt
}
quit() { exit }
zle -N pwd-to-clip
zle -N cd-to-clip
zle -N quit
bindkey -M viins ,y pwd-to-clip
bindkey -M viins ,p cd-to-clip
bindkey -M viins ,q quit

# Rebind C-M-x and ,. to run previous command
run_previous_command() { zle -U "!!"; }
zle -N run-previous-command run_previous_command
bindkey "^[^X" run-previous-command
bindkey -M viins ,. run-previous-command

# Rebind M-s to insert 'sudo ' at start
insert_sudo() { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# For making things colourful
alias colourise='grc --stdout --stderr --colour=auto'

alias c='cd'
alias chx='chmod +x'
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
alias df='df -h'
alias diff='diff --color=auto'
alias dns='dig +short'
alias du='du -h'
alias fehbg='feh --bg-fill'
alias free='free -h'
alias g='hub'
alias grep='grep --color'
alias gs='git s' # typo guard
alias ka='killall'
alias la='ls -a'
alias ll='ls -lh'
alias l='ls'
alias l.='ls -d .*'
alias ls='ls --color=auto'
alias md='mkdir --parents'
alias more='less'
alias mp='mpv --no-audio-display --term-osd-bar --term-osd-bar-chars="╶── ╴"'
alias msa='mp --shuffle **/*'
alias mssa='mp --shuffle --no-audio-display **/*.(aac|mp3|ogg|oga|midi|wma|flac)'
alias nh=' unset HISTFILE'
alias pg='ping google.com'
alias ping='colourise ping'
alias .='pwd'
alias sc='ssh cyan.io'
alias sxa='ls | shuf | sxiv -a -i'
alias sxiv='sxiv -a'
alias sx='startx'
alias top='htop'
alias v='nvim'
alias xci='xclip -i -selection clipboard'
alias xco='xclip -o -selection clipboard'
alias sudo="sudo --prompt='$(print -P %S%F{15}sudo%f%s password for %F{yellow}%%U%f) > '"
autoload -U zmv ; alias mmv='noglob zmv -W' # pattern-matching mv

if [[ $(which pacman) ]]; then
    alias pacr='sudo pacman -Rsc'
    alias pacs='pacman -Ss'
    alias pac='sudo pacman -S'
    alias pacu='sudo pacman -Syu'
    alias pacU='sudo pacman -U'
fi

# Keep ibus happy
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XIM_PROGRAM="/usr/bin/ibus-daemon --xim"
export XMODIFIERS="@im=ibus"

# Keys. Lots of keys.
# zsh is a bit of a bitch in getting these right without help.
# This is thanks to https://github.com/slashbeast/things/blob/master/configs/DOTzshrc
case $TERM in
    rxvt*|xterm*)
        bindkey "^[[7~" beginning-of-line #Home key
        bindkey "^[[8~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        #bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;

    linux)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward
        bindkey "^[[B" history-beginning-search-forward
    ;;

    screen|screen-*)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        #bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;
esac

# Jump words with C-leftarrow and C-rightarrow
bindkey "^[[1;5D" vi-backward-word
bindkey "^[[1;5C" vi-forward-word

# Open command line in editor with C-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Black magic to figure out the directory in which this file resides, even
# through a symlink.  All this just so we can `source` files from here
# regardless of where "here" is.
#
# Props to https://stackoverflow.com/a/246128/777586
SOURCE=${(%):-%N}
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTS_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Load archive extract script (binds to 'x')
source $DOTS_DIR/extract.zsh

# Load right-hand-side git prompt
source $DOTS_DIR/git-prompt.zsh

# Load fuzzy finder binds (M-c for cd, C-t for file, C-r for command)
source /usr/share/fzf/key-bindings.zsh
