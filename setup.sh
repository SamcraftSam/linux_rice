#!/bin/bash

echo "====[ NVIM CONFIG INSTALLATION ]===="

command -v nvim >/dev/null 2>&1 || { echo "Neovim is not found"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Git is not found"; exit 1; }
command -v pip3 >/dev/null 2>&1 || { echo "Python-pip is not found"; exit 1; }

command -v pip3 install --user ipython jupytext

[ -d ~/.config/nvim ] || mkdir -p ~/.config/nvim
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
cp "$(dirname "$0")/nvim/init.lua" ~/.config/nvim/init.lua

echo "COMPLETED!"
