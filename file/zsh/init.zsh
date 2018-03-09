bindkey -v

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST="$HISTSIZE"

export TERM=xterm-256color
export EDITOR=nvim
export BROWSER=chromium

export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XIM_PROGRAM="/usr/bin/ibus-daemon --xim"
export XMODIFIERS="@im=ibus"

setopt INTERACTIVE_COMMENTS ; # Allow comments on command line
setopt EXTENDED_GLOB ; # Enable additional glob patterns
setopt NOTIFY ; # Report on background job status immediately
setopt NO_BEEP ; # Disable system bell
setopt AUTO_CD ; # Automatically cd to typed directories
setopt AUTO_PUSHD ; # Automatically push directories onto directory stack
setopt AUTO_CONTINUE ; # Automatically continue disowned processes
setopt HIST_IGNORE_SPACE ; # Commands starting with a space bypass history
setopt HIST_NO_STORE ; # Don't store history commands themselves in history
setopt HIST_IGNORE_DUPS ; # Ignore consecutive duplicates in history
setopt INC_APPEND_HISTORY ; # Write history file immediately (not on exit)

function command_not_found_handler() {
    print -P "%F{001}Missing command %F{009}$1%f";
    exit 127
}

autoload -Uz compinit
compinit
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select # Show matches in menu when tabbing through

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# For making things colourful
alias colourise='grc --stdout --stderr --colour=auto'

alias .='pwd'
alias c='clip'
alias chx='chmod +x'
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
alias df='df -h'
alias diff='diff --color=auto'
alias dns='dig +short'
alias du='du -h'
alias fehbg='feh --bg-fill'
alias free='free -h'
alias g='hub'
alias gpg='gpg2'
alias grep='grep --color'
alias gs='git s' # typo guard
alias i3r='i3-restore-tree'
alias ka='killall'
alias l.='ls -d .*'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ls='ls --color=auto'
alias lt='ls --sort=time'
alias md='mkdir --parents'
alias more='less'
alias mp='mpv --no-audio-display --term-osd-bar --term-osd-bar-chars="╶── ╴"'
alias msa='mp --shuffle **/*'
alias mssa='mp --shuffle --no-audio-display **/*.(aac|mp3|ogg|oga|midi|wma|flac)'
alias nh=' unset HISTFILE'
alias pg='ping google.com'
alias ping='colourise ping'
alias sc='ssh cyan.io'
alias sudo="sudo --prompt='$(print -P %S%F{15}sudo%f%s password for %F{yellow}%%U%f) > '"
alias sx='startx'
alias sxa='ls | shuf | sxiv -a -i'
alias sxiv='sxiv -a'
alias tmp='cd $(mktemp --directory)'
alias top='htop'
alias v='nvim'
autoload -U zmv ; alias mmv='noglob zmv -W' # pattern-matching mv

# Conditional aliases for package management tools
if [[ $(which pacman) ]]; then
    alias pacr='sudo pacman -Rsc'
    alias pacs='pacman -Ss'
    alias pac='sudo pacman -S'
    alias pacu='sudo pacman -Syu'
    alias pacU='sudo pacman -U'
fi
if [[ $(which xbps-install) ]]; then
    alias xr='sudo xbps-remove'
    alias xs='xbps-query -Rs'
    alias xi='sudo xbps-install -S'
    alias xu='sudo xbps-install -Su'
fi

# Bind up and down arrow keys to prefix-search history
bindkey "^[[A" history-beginning-search-backward #Up Arrow
bindkey "^[[B" history-beginning-search-forward #Down Arrow

# Bind ,y to yank CWD and ,p to paste it
# Nice for quickly getting multiple terminal windows into the same dir.
pwd-to-clip() { pwd | clip i }
cd-to-clip() { cd "$(clip o)" ; zle reset-prompt }
zle -N pwd-to-clip
zle -N cd-to-clip
bindkey '\C-y' pwd-to-clip
bindkey '\C-p' cd-to-clip
bindkey -M viins ,y pwd-to-clip
bindkey -M viins ,p cd-to-clip

# Bind ,. to run previous command
run_previous_command() { zle -U "!!"; }
zle -N run-previous-command run_previous_command
bindkey -M viins ,. run-previous-command

# Bind M-s to insert 'sudo ' at start
insert_sudo() { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Bind C-leftarrow and C-rightarrow to jump words
bindkey "^[[1;5D" vi-backward-word
bindkey "^[[1;5C" vi-forward-word

# Bind C-e to open the command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Bind C-f to search for and insert a file with fzy
insert_fzy_path() {
    local selected_path
    selected_path=$(fd --hidden | fzy -l20) || return
    zle -U "${(q)selected_path}"
    zle reset-prompt
}
zle -N insert-fzy-path insert_fzy_path
bindkey "^f" insert-fzy-path

# Bind C-r to search for and insert a history line with fzy
insert_fzy_history() {
    local selected_command
    selected_command=$(cat "$HISTFILE" | fzy -l20) || return
    zle -U "$selected_command"
    zle reset-prompt
}
zle -N insert-fzy-history insert_fzy_history
bindkey "^r" insert-fzy-history

# Black magic hackery to figure out the directory in which this current file
# resides, even through a symlink.  All this is just so we can `source` files
# from this directory here, as in where "here" actually resolves to.
#
# Props to https://stackoverflow.com/a/246128/777586
SOURCE=${(%):-%N}
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTS_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $DOTS_DIR/extract.zsh     # Load archive extract script (binds to 'x')
source $DOTS_DIR/git-prompt.zsh  # Load right-side prompt (git stuff)
source $DOTS_DIR/left-prompt.zsh # Load left-side prompt
