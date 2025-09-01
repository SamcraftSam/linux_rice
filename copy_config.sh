#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/.config/nvim"
DST="/home/alex/GitRepos/linux_rice/nvim"

# Make sure source exists
if [ ! -d "$SRC" ]; then
  echo "Error: $SRC does not exist."
  exit 1
fi

# Create destination if missing
mkdir -p "$DST"

# Wipe old contents
rm -rf "$DST"/*

# Copy everything fresh
cp -r "$SRC"/* "$DST"/

echo "Copied Neovim config from $SRC → $DST"

