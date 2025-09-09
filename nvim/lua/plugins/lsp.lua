return {
  -- Mason: installs external tools (LSP servers)
  { "williamboman/mason.nvim", config = true },

  -- Mason-LSPConfig: links Mason-installed servers to lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "tsserver", "rust_analyzer", "clangd" },
      })
    end,
  },

  -- nvim-lspconfig: actual LSP client setup
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      for _, server in ipairs({ "lua_ls","pyright","tsserver","rust_analyzer","clangd" }) do
        lspconfig[server].setup({})
      end
    end,
  },
}

