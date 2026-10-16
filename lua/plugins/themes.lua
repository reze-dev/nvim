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
        table.sort(names)
        return names
      end

      local function apply_theme(name)
        base46.load(name)
        vim.api.nvim_exec_autocmds("ColorScheme", {})
      end

      -- nvim-notify has no base46 integration in this version; without a
      -- background it renders translucent windows and warns on every notify.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ThemeNotifyBackground", { clear = true }),
        callback = function()
          local base46 = require("base46")
          local ok, colors = pcall(function()
            return base46.theme_tables[base46.current_theme].base_30
          end)
          -- base_30 has no `base` entry in this catalogue; darker_black is the
          -- page-background depth, which is what a notification backdrop wants.
          local bg = ok and type(colors) == "table" and (colors.darker_black or colors.black) or nil
          if not bg then
            bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
          end
          if bg then
            vim.api.nvim_set_hl(0, "NotifyBackground", { bg = type(bg) == "number" and ("#%06x"):format(bg) or bg })
          end
        end,
      })

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
      -- Fall back to the previous rose-pine aesthetic for fresh installs
      -- (no persisted theme state yet).
      apply_theme(saved_theme or "rosepine")

      vim.api.nvim_create_user_command("NvChadTheme", function()
        require("base46-themes").pick()
      end, { desc = "Choose an NvChad Base46 colorscheme" })
    end,
  },
}
