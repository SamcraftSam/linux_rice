-- ==========================
-- == БАЗОВЫЕ НАСТРОЙКИ  ==
-- ==========================

vim.cmd('syntax on')  -- Включаем синтаксис
vim.cmd([[
    filetype on
    filetype indent on
    filetype plugin on
]])
vim.o.compatible = false  -- Отключаем Vi-режим

-- Настройки табов и отступов
vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.softtabstop = 8
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Улучшения UI
vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.history = 100
vim.o.wildmenu = true
vim.o.laststatus = 2
vim.o.showtabline = 2

-- Цветовая схема Gruvbox (не ломается, если не установлен)
pcall(vim.cmd, 'colorscheme gruvbox')

-- ==========================
-- == ГОРЯЧИЕ КЛАВИШИ     ==
-- ==========================

vim.keymap.set('n', '<leader>c', ':tabedit<Space>')  -- Открыть новую вкладку
vim.keymap.set('n', '<leader>cc', ':set colorcolumn=80<CR>')  -- Включить colorcolumn
vim.keymap.set('n', '<leader>ncc', ':set colorcolumn=0<CR>')  -- Выключить colorcolumn

-- Буферы
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')  -- Следующий буфер
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>')  -- Предыдущий буфер
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')  -- Закрыть буфер

-- ==========================
-- == УСТАНОВКА ПЛАГИНОВ  ==
-- ==========================

-- Устанавливаем Lazy.nvim (если его нет)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Подключаем плагины через Lazy.nvim
require('lazy').setup({
    -- Файловый менеджер (замена Netrw)
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- Цветовая схема Gruvbox
    'morhetz/gruvbox',
    {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-\>]],
        direction = 'horizontal',
      })
    end,
   },
})

-- ==========================
-- == НАСТРОЙКА NVIM-TREE  ==
-- ==========================

require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    renderer = {
        icons = {
            show = {
                git = false,
                folder = true,
                file = true,
            },
        },
    },
    git = {
        enable = true,
    },
})

-- ==========================
-- == НАСТРОЙКА ТЕРМИНАЛА  ==
-- ==========================
require("toggleterm").setup({
    size = 15,               -- Высота терминала (в строках)
    open_mapping = [[<C-\>]], -- Горячая клавиша для открытия/закрытия
    direction = 'horizontal', -- 'vertical' | 'horizontal' | 'float'
    shade_terminals = true,   -- Затемнение основного окна
    persist_size = true,      -- Запоминать размер
    close_on_exit = true,     -- Закрывать терминал при выходе
    shell = vim.o.shell,      -- Использовать системную оболочку (bash/zsh)
})

-- Горячие клавиши для терминала
vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true }) -- Выход из терминала в нормальный режим
vim.cmd([[autocmd VimEnter * ToggleTerm]])

require("toggleterm").setup({
    on_open = function(term)
        vim.cmd("startinsert!")  -- Автоматически войти в режим ввода
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})
    end,
})

-- Горячие клавиши для NvimTree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

