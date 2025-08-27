-- ==========================
-- ==    BASIC SETTINGS    ==
-- ==========================

vim.cmd('syntax on') 
vim.cmd([[
    filetype on
    filetype indent on
    filetype plugin on
]])
vim.o.compatible = false

vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.softtabstop = 8
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true


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

pcall(vim.cmd, 'colorscheme gruvbox')

-- ==========================
-- == ГОРЯЧИЕ КЛАВИШИ     ==
-- ==========================

vim.keymap.set('n', '<leader>c', ':tabedit<Space>')  
vim.keymap.set('n', '<leader>cc', ':set colorcolumn=80<CR>')
vim.keymap.set('n', '<leader>ncc', ':set colorcolumn=0<CR>') 

-- Буферы
vim.keymap.set('n', '<leader>bn', ':bnext<CR>') 
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>') 
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>') 

-- ==========================
-- == УСТАНОВКА ПЛАГИНОВ  ==
-- ==========================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
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
  { "goerz/jupytext.vim" },
  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")
      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {command = {"ipython"}},
	    ipynb = {command = { "jupyter", "console", "--existing" }},
	    markdown = {command = {"ipython"}},
          },
          repl_open_cmd = require("iron.view").split.vertical.botright()
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      }
    end
  }
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
    size = 15,               
    open_mapping = [[<C-\>]], 
    direction = 'horizontal', 
    shade_terminals = true,   
    persist_size = true,      
    close_on_exit = true,     
    shell = vim.o.shell,
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})
    end,
})

vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.cmd([[autocmd VimEnter * ToggleTerm]])
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

