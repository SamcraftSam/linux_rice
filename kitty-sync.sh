
#!/usr/bin/env bash
set -e

STD="$HOME/.config/kitty"
CUR="$(pwd)/kitty"

usage() {
    echo "Use it like this:"
    echo "  $0 -w   — push ./kitty → ~/.config/kitty"
    echo "  $0 -r   — pull ~/.config/kitty → ./kitty"
    exit 1
}

[ $# -ne 1 ] && usage

mkdir -p "$STD"

case "$1" in
    -w)
        if [ ! -d "$CUR" ]; then
            echo "There's no './kitty/' in this directory."
            exit 1
        fi
        echo ">>> Copying $CUR → $STD"
        rsync -av --delete "$CUR/" "$STD/"
        echo "Done."
        ;;
    -r)
        echo ">>> Copying $STD → $CUR"
        mkdir -p "$CUR"
        rsync -av --delete "$STD/" "$CUR/"
        echo "Done."
        ;;
    *)
        usage
        ;;
esac
