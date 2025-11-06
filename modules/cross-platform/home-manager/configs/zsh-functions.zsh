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

# upfast
upfast () {
    curl -F "file=@$(readlink -f $1)" "https://upfast.cronyakatsuki.xyz/"
}
