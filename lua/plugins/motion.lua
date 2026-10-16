-- ─── Motion Training & Navigation Tools ───────────────────────────
return {
  -- Hardtime — train better vim movement habits (opt-in via <leader>uh / :Hardtime)
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
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
      enabled = false,
      max_count = 3,
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "oil",
        "snacks_dashboard",
        "snacks_picker_input",
        "snacks_picker_list",
        "dashboard",
        "trouble",
        "harpoon",
        "help",
        "undotree",
        "dap-view",
        "dap-view-term",
        "dap-repl",
      },
      disabled_buftypes = { "nofile", "prompt", "quickfix", "terminal" },
    },
  },

  -- Precognition — visualize motion destinations (opt-in via <leader>up)
  {
    "tris203/precognition.nvim",
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

  -- Flash — blazing fast jump motions (key-lazy only, no VeryLazy)
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      {
        "s",
        -- NOTE: not in normal mode — mini.surround needs `s` prefix there (ys, cs, ds).
        mode = { "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "x", "o" },
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
