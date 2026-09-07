-- ─── NvChad themes — colors only, no NvChad UI ────────────────
-- AvengeMedia/base46 is the NvChad-independent distribution of Base46. It
-- ships the NvChad theme catalogue as ordinary colorschemes and does not pull
-- in NvChad's statusline, tabline, file tree, or other UI plugins.
return {
  {
    "AvengeMedia/base46",
    version = "v3.0",
    lazy = false,
    opts = {
      transparency = true,
      set_background = true,
      term_colors = true,
      -- Integrate colors with plugins already in this config, while leaving
      -- NvChad UI modules entirely out of the dependency graph.
      integrations = {
        defaults = true,
        syntax = true,
        treesitter = true,
        lsp = true,
        telescope = true,
        whichkey = true,
        gitsigns = true,
        bufferline = true,
        devicons = true,
        blink = true,
        statusline = false,
        neotest = true,
      },
    },
    keys = {
      {
        "<leader>ut",
        function()
          require("base46-themes").pick()
        end,
        desc = "Themes: choose NvChad theme",
      },
    },
    cmd = { "NvChadTheme" },
    config = function(_, opts)
      local base46 = require("base46")
      local theme_state = require("core.theme")
      base46.setup(opts)

      local function theme_names()
        local names = {}
        for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)) do
          local name = vim.fn.fnamemodify(path, ":t:r")
          names[#names + 1] = name
        end
        -- Monoglow is a regular colorscheme, not a Base46 theme, but it can
        -- still participate in this picker without changing Base46 itself.
        names[#names + 1] = "monoglow"
        table.sort(names)
        return names
      end

      local function apply_theme(name)
        if name == "monoglow" then
          vim.cmd.colorscheme("monoglow")
        else
          base46.load(name)
          vim.api.nvim_exec_autocmds("ColorScheme", {})
        end
      end

      package.preload["base46-themes"] = function()
        return {
          pick = function()
            vim.ui.select(theme_names(), { prompt = "NvChad theme" }, function(choice)
              if choice then
                theme_state.write_base46_theme(choice)
                apply_theme(choice)
                vim.notify("Theme: " .. choice, vim.log.levels.INFO)
              end
            end)
          end,
        }
      end

      local saved_theme = theme_state.read_base46_theme()
      if saved_theme then
        apply_theme(saved_theme)
      end

      vim.api.nvim_create_user_command("NvChadTheme", function()
        require("base46-themes").pick()
      end, { desc = "Choose an NvChad Base46 colorscheme" })
    end,
  },
}
