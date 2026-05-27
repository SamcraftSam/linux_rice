#!/usr/bin/env bash
set -euo pipefail

CONFIG_NAME="nvim"

STD="$HOME/.config/$CONFIG_NAME"
CUR="$(pwd)/$CONFIG_NAME"

usage() {
    cat <<EOF
Usage:
  $0 -w        Push local ./$CONFIG_NAME → ~/.config/$CONFIG_NAME
  $0 -r        Pull ~/.config/$CONFIG_NAME → ./$CONFIG_NAME
  $0 -d        Open diff between local and system configs
  $0 -h        Show this help
EOF
    exit 1
}

backup_dir() {
    local target="$1"

    if [ -d "$target" ] && [ "$(ls -A "$target" 2>/dev/null)" ]; then
        local backup="${target}.bak.$(date +%Y%m%d_%H%M%S)"

        echo ">>> Backing up existing config:"
        echo "    $target → $backup"

        mv "$target" "$backup"
    fi
}

diff_dirs() {
    if ! command -v nvim >/dev/null 2>&1; then
        echo "Error: nvim is not installed."
        exit 1
    fi

    if ! command -v diff >/dev/null 2>&1; then
        echo "Error: diff is not installed."
        exit 1
    fi

    echo ">>> Comparing configs..."
    echo "    LOCAL : $CUR"
    echo "    SYSTEM: $STD"
    echo

    local files
    files=$(diff -qr "$CUR" "$STD" | awk '{print $2}' || true)

    if [ -z "$files" ]; then
        echo "Configs are identical."
        exit 0
    fi

    while IFS= read -r file; do
        rel="${file#$CUR/}"

        local_file="$CUR/$rel"
        system_file="$STD/$rel"

        if [ -f "$local_file" ] && [ -f "$system_file" ]; then
            echo ">>> Opening diff for: $rel"
            nvim -d "$local_file" "$system_file"
        fi
    done <<< "$files"
}

[ $# -ne 1 ] && usage

case "$1" in
    -w)
        if [ ! -d "$CUR" ]; then
            echo "Error: local config '$CUR' does not exist."
            exit 1
        fi

        backup_dir "$STD"

        mkdir -p "$STD"

        echo ">>> Syncing local → system"
        echo "    $CUR → $STD"

        rsync -av --delete "$CUR/" "$STD/"

        echo "Done."
        ;;

    -r)
        if [ ! -d "$STD" ]; then
            echo "Error: system config '$STD' does not exist."
            exit 1
        fi

        backup_dir "$CUR"

        mkdir -p "$CUR"

        echo ">>> Syncing system → local"
        echo "    $STD → $CUR"

        rsync -av --delete "$STD/" "$CUR/"

        echo "Done."
        ;;

    -d)
        if [ ! -d "$CUR" ]; then
            echo "Error: local config '$CUR' does not exist."
            exit 1
        fi

        if [ ! -d "$STD" ]; then
            echo "Error: system config '$STD' does not exist."
            exit 1
        fi

        diff_dirs
        ;;

    -h|--help)
        usage
        ;;

    *)
        usage
        ;;
esac
