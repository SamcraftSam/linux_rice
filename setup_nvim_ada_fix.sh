#!/bin/bash

echo "====[ NVIM CONFIG INSTALLATION ]===="

command -v nvim >/dev/null 2>&1 || { echo "Neovim is not found"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Git is not found"; exit 1; }
command -v pip3 >/dev/null 2>&1 || { echo "Python-pip is not found"; exit 1; }

[ -d ~/.config/nvim ] || mkdir -p ~/.config/nvim
[ -d ~/.config/nvim/after ] || mkdir -p ~/.config/nvim/after
[ -d ~/.config/nvim/after/ftplugin ] || mkdir -p ~/.config/nvim/after/ftplugin
cp "$(dirname "$0")/nvim_ada_fix/ada.lua" "~/.config/nvim/after/ftplugin/ada.lua"
