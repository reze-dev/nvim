-- ─── NvChad themes — colors only, no NvChad UI ────────────────
-- AvengeMedia/base46 is the NvChad-independent distribution of Base46. It
-- ships the NvChad theme catalogue as ordinary colorschemes and does not pull
-- in NvChad's statusline, tabline, file tree, or other UI plugins.
return {
  {
    "AvengeMedia/base46",
    version = "v3.0",
    lazy = false,
    priority = 1000,
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
      local ok_base46, base46 = pcall(require, "base46")
      if not ok_base46 then
        return
      end
      local ok_state, theme_state = pcall(require, "core.theme")
      if not ok_state then
        base46.setup(opts)
        base46.load("rosepine")
        return
      end
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
        -- base46.load already fires ColorScheme; listeners (lualine, notify
        -- bg) refresh from that. No manual exec needed.
      end

      -- nvim-notify has no base46 integration in this version; without a
      -- background it renders translucent windows and warns on every notify.
      -- NOTE: transparency=true leaves Normal with no bg, so we must never
      -- inherit a nil bg — always fall back to a solid hex.
      local function sync_notify_bg()
        local bg = nil
        local ok_base, base46_mod = pcall(require, "base46")
        if ok_base then
          local ok, colors = pcall(function()
            return base46_mod.theme_tables[base46_mod.current_theme].base_30
          end)
          if ok and type(colors) == "table" then
            bg = colors.darker_black or colors.black
          end
          if not bg and base46_mod.get_builtin_theme and base46_mod.current_theme then
            local ok2, theme = pcall(base46_mod.get_builtin_theme, base46_mod.current_theme)
            if ok2 and type(theme) == "table" then
              local b30 = theme.base_30 or {}
              bg = b30.darker_black or b30.black
            end
          end
        end
        if not bg then
          local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
          bg = normal.bg
        end
        if not bg then
          local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
          bg = nf.bg
        end
        if type(bg) == "number" then
          bg = ("#%06x"):format(bg)
        end
        if type(bg) ~= "string" or bg == "" then
          bg = "#1e1e2e"
        end
        vim.api.nvim_set_hl(0, "NotifyBackground", { bg = bg })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ThemeNotifyBackground", { clear = true }),
        callback = sync_notify_bg,
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
      -- base46.load fires ColorScheme synchronously, but the palette table
      -- may only be populated afterwards — sync once on next tick too so
      -- NotifyBackground is never left without a bg (nvim-notify warns).
      vim.schedule(sync_notify_bg)

      vim.api.nvim_create_user_command("NvChadTheme", function()
        require("base46-themes").pick()
      end, { desc = "Choose an NvChad Base46 colorscheme" })
    end,
  },
}
