return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
    keys = {
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "LSP code action",
        mode = { "n", "v" },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "rust",
        "go",
        "nix",
      },
      auto_install = true,
    },
  },
}
