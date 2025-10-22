-- ==========================
-- ==    BASIC SETTINGS    ==
-- ==========================

require("kitty_colors").apply()
vim.cmd('syntax on') 
vim.cmd([[
    filetype on
    filetype indent on
    filetype plugin on
]])
vim.o.compatible = false

vim.opt.tabstop = 4        -- Number of visual spaces per TAB
vim.opt.shiftwidth = 4      -- Number of spaces to use for (auto)indent
vim.opt.expandtab = true     -- Convert tabs to spaces

vim.o.softtabstop = 4
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true


vim.o.number = true
vim.o.cursorline = false
vim.o.cursorcolumn = false
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.history = 100
vim.o.wildmenu = true
vim.o.laststatus = 2
vim.o.showtabline = 2

--pcall(vim.cmd, 'colorscheme gruvbox')

-- ==============
-- == HOT KEYS ==
-- ==============
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>c', ':tabedit<Space>')  
vim.keymap.set('n', '<leader>cc', ':set colorcolumn=80<CR>')
vim.keymap.set('n', '<leader>ncc', ':set colorcolumn=0<CR>') 

-- Buffers
vim.opt.clipboard = "unnamedplus"

vim.keymap.set('n', '<leader>bn', ':bnext<CR>') 
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>') 
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>') 

-- ==========================
-- == PLAGIN INSTALLATION  ==
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
  {
    "MIBismuth/matlab.nvim",
    config = function()
        require('matlab').setup({
            matlab_dir = "/home/alex/Apps/matlab/bin/matlab"
        })
    end,
  },

    -- Mason: installs external tools (LSP servers)
    { 
      "williamboman/mason.nvim", config = true 
    },

    -- Mason-LSPConfig: links Mason-installed servers to lspconfig
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "pyright","clangd" },
        })
      end,
    },

    -- nvim-lspconfig: actual LSP client setup
    {
      "neovim/nvim-lspconfig",
      dependencies = { "williamboman/mason-lspconfig.nvim" },
      config = function()
        local lspconfig = require("lspconfig")
        for _, server in ipairs({ "lua_ls","pyright","clangd" }) do
          lspconfig[server].setup({})
        end
      end,
    },
    {
      "rmagatti/goto-preview",
      dependencies = { "rmagatti/logger.nvim" },
      event = "BufEnter",
      config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    },
{ "nvim-telescope/telescope.nvim", dependencies = "tsakirist/telescope-lazy.nvim" }
  
})

-- =====================
-- == NVIM-TREE SETUP ==
-- =====================

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

-- ===================
-- == LSP AND STUFF ==
-- ===================
require('goto-preview').setup {
  width = 120, -- Width of the floating window
  height = 15, -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}, -- Border characters of the floating window
  default_mappings = false, -- Bind default mappings
  debug = false, -- Print debug information
  opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  references = { -- Configure the telescope UI for slowing the references cycling window.
    provider = "telescope", -- telescope|fzf_lua|snacks|mini_pick|default
    telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
  },
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true, -- Focus the floating window when opening it.
  dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true, -- Whether to nest floating windows
  same_file_float_preview = true, -- Whether to open a new floating window for a reference within the current file
  preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
  zindex = 1, -- Starting zindex for the stack of floating windows
  vim_ui_input = true, -- Whether to override vim.ui.input with a goto-preview floating window
 
}


-- init.lua or plugin setup file
require('goto-preview').setup {}

-- Keybinding example: Preview definition with <leader>pd
vim.api.nvim_set_keymap(
  'n',                             -- normal mode
  '<leader>gd',                    -- your keybinding
  "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  { noremap = true, silent = true } -- don't remap, no echo
)

vim.keymap.set("n", "gs", function()
    require("telescope.builtin").lsp_definitions()
    end, { noremap = true, silent = true })

--vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { noremap = true, silent = true })

-- Optional: Preview implementation, references, etc.
vim.api.nvim_set_keymap('n', '<leader>gi', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>gr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>gq', "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap=true, silent=true })

vim.diagnostic.enable(false)

--- ===============
--- == TELESCOPE ==
--- ===============

require("telescope").setup({
  extensions = {
    -- Type information can be loaded via 'https://github.com/folke/lazydev.nvim'
    -- by adding the below two annotations:
    ---@module "telescope._extensions.lazy"
    ---@type TelescopeLazy.Config
    lazy = {
      -- Optional theme (the extension doesn't set a default theme)
      theme = "ivy",
      -- The below configuration options are the defaults
      show_icon = true,
      mappings = {
        open_in_browser = "<C-o>",
        open_in_file_browser = "<M-b>",
        open_in_find_files = "<C-f>",
        open_in_live_grep = "<C-g>",
        open_in_terminal = "<C-t>",
        open_plugins_picker = "<C-b>",
        open_lazy_root_find_files = "<C-r>f",
        open_lazy_root_live_grep = "<C-r>g",
        change_cwd_to_plugin = "<C-c>d",
      },
      actions_opts = {
        open_in_browser = {
          auto_close = false,
        },
        change_cwd_to_plugin = {
          auto_close = false,
        },
      },
      terminal_opts = {
        relative = "editor",
        style = "minimal",
        border = "rounded",
        title = "Telescope lazy",
        title_pos = "center",
        width = 0.5,
        height = 0.5,
      },
      -- Other telescope configuration options
    },
  },
})

require("telescope").load_extension("lazy")

-- ====================
-- == MATLAB KEYMAPS ==
-- ====================

vim.api.nvim_set_keymap('n', '<leader>mo', ':MatlabCliOpen<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>mc', ':MatlabCliCancelOperation<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>mh', ':MatlabHelp<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>md', ':MatlabDoc<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>me', ':MatlabOpenEditor<CR>', {})
vim.api.nvim_set_keymap('v', '<leader>mr', ':<C-u>execute "MatlabCliRunSelection"<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>mw', ':MatlabOpenWorkspace<CR>', {})
vim.api.nvim_set_keymap('n', '<leader><CR>', ':MatlabCliRunCell<CR>', {})

-- ===============
-- == CLI SETUP ==
-- ===============
local Terminal  = require('toggleterm.terminal').Terminal

--require("toggleterm").setup({
local main_term = Terminal:new({
    size = 15,               
    --open_mapping = [[<C-\>]], 
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
-- vim.cmd([[autocmd VimEnter * ToggleTerm]])
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- ===================
-- == ESP-IDF SETUP ==
-- ===================

-- change this path to where your esp-idf export.sh lives
local idf_export = os.getenv("HOME") .. "/esp/v5.4/esp-idf/export.sh"

-- custom terminal that sources IDF venv
local idf_term = Terminal:new({
  id = 1,
  size = 15,                
  cmd = "bash -c 'source " .. idf_export .. " && exec bash'",
  hidden = true,
  direction = "horizontal",
  shade_terminals = true,   
  persist_size = true,      
  close_on_exit = true,     
  shell = vim.o.shell,
})

function _IDF_TOGGLE()
  idf_term:toggle()
end

-- Keybind: open ESP-IDF terminal
vim.keymap.set('n', '<leader>te', _IDF_TOGGLE, { noremap = true, silent = true })
