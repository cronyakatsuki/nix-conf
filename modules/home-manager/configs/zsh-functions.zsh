#!/usr/bin/env zsh
# Open a script in path with vim quicly
vish () {
    nvim $(which $1)
}

# Create a directory and change into it
md () {
    mkdir -p "$@" && cd "$@"
}

# Move a file and create a link in it's place
mvln () {
    from=$(readlink -f $1)
    to="$2"
    [ ! -d "$(dirname $to)" ] && mkdir -p "$(dirname $to)"
    mv $from $to
    ln -s $to $from
}

# nnn
n () {
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # Tempfile location
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

# upfast
upfast () {
    curl -F "file=@$(readlink -f $1)" "https://upfast.cronyakatsuki.xyz/"
}
