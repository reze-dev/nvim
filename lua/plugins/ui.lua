-- ─── UI Enhancements ──────────────────────────────────────────
return {
  -- Web devicons (dependency for many plugins)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    -- Keep the plugin's maintained Nerd Font icon catalogue. The old config
    -- overrode these entries with empty strings, which hid icons everywhere.
    opts = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        show_start = false,
        show_end = false,
        include = {
          node_type = {
            ["*"] = {
              "argument_list",
              "arguments",
              "assignment_statement",
              "block",
              "chunk",
              "class",
              "do_block",
              "element",
              "except",
              "for",
              "function",
              "if_statement",
              "method",
              "object",
              "return_statement",
              "table",
              "try",
              "while",
            },
          },
        },
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "snacks_dashboard",
          "lazy",
          "mason",
          "notify",
          "oil",
          "harpoon",
          "toggleterm",
        },
      },
    },
  },

  -- Notify — solid background so nvim-notify never warns about
  -- 'NotifyBackground has no background highlight' (we use transparency=true,
  -- so Normal itself has no bg to inherit).
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      background_colour = "#1e1e2e",
    },
  },

  -- Noice — modern UI for messages, cmdline, and popups
  -- NOTE: explicit `config` — lazy.nvim's main-module resolution silently
  --       skipped `setup` for this spec (noice never activated otherwise).
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("noice").setup(opts)
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        hover = { enabled = true },
        -- blink.cmp owns the automatic signature window (completion.lua);
        -- keeping noice's would render a second signature popup.
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        -- Hide "written" messages
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect cmdline",
      },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
    },
  },

  -- Illuminate — highlight word under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "oil",
        "dashboard",
        "snacks_dashboard",
        "lazy",
        "mason",
        "snacks_picker_input",
        "snacks_picker_list",
        "TelescopePrompt",
        "dap-view",
        "dap-view-term",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Colorizer — inline color preview
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*", "!lazy", "!mason", "!snacks_dashboard", "!dashboard" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = false,
        virtualtext = "■",
        always_update = false,
      },
    },
  },
}
