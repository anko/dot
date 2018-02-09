make_prompt() {

    local COLOUR_MAIN=023
    local COLOUR_GIT_ROOT=243
    local COLOUR_GIT_ROOT_BASENAME=015
    local COLOUR_BASENAME=051

    # cd to the given directory so we can use zsh's prompt expansion (print -P)
    # with %~ expanded relative to it.
    print_at() {
        ( cd -q $2 ; print -P $1 )
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
            "39"|"vertex")
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
