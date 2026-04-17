return {
  {
    "leoluz/nvim-dap-go",
    ft = { "go" },
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
    keys = {
      {
        "<Leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debugger run Golang test",
        ft = "go",
      },
      {
        "<Leader>dgl",
        function()
          require("dap-go").debug_last_test()
        end,
        desc = "Debugger run last Golang test",
        ft = "go",
      },
    },
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
    keys = {
      {
        "<Leader>gj",
        "<cmd> GoTagAdd json<CR>",
        desc = "Add json struct tags",
        ft = "go",
      },
      {
        "<Leader>gy",
        "<cmd> GoTagAdd yaml<CR>",
        desc = "Add yaml struct tags",
        ft = "go",
      },
    },
  },
}
