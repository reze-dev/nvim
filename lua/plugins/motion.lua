-- ─── Motion Training & Navigation Tools ───────────────────────────
return {
  -- Hardtime — train better vim movement habits
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    cmd = { "Hardtime" },
    keys = {
      {
        "<leader>uh",
        function()
          require("hardtime").toggle()
        end,
        desc = "Toggle Hardtime (motion trainer)",
      },
    },
    opts = {
      max_count = 3,
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "oil",
        "snacks_dashboard",
        "dashboard",
        "trouble",
        "harpoon",
        "help",
        "undotree",
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_stacks",
        "dapui_watches",
        "dap-repl",
        "dapui_console",
      },
      disabled_buftypes = { "nofile", "prompt", "quickfix", "terminal" },
    },
  },

  -- Precognition — visualize motion destinations
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    cmd = { "Precognition" },
    keys = {
      {
        "<leader>up",
        function()
          require("precognition").toggle()
        end,
        desc = "Toggle Precognition (motion guide)",
      },
    },
    opts = {
      start_visible = false,
      show_blank = true,
    },
  },

  -- Flash — blazing fast jump motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        -- NOTE: not in normal mode — nvim-surround needs `s` there (ys, cs, ds).
        mode = { "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash search",
      },
    },
  },
}
