-- ─── Rose Pine Colorscheme ────────────────────────────────────
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  lazy = false,
  opts = {
    variant = "main",
    dark_variant = "main",
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    styles = {
      bold = true,
      italic = true,
      transparency = true,
    },

    highlight_groups = {
      -- Blend with the base background
      TelescopeBorder = { fg = "highlight_high", bg = "none" },
      TelescopeNormal = { bg = "none" },
      TelescopePromptNormal = { bg = "base" },
      TelescopeResultsNormal = { fg = "subtle", bg = "none" },
      TelescopeSelection = { fg = "text", bg = "base" },
      TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

      -- Float borders
      FloatBorder = { fg = "highlight_high", bg = "surface" },
      NormalFloat = { bg = "surface" },

      -- Cursorline
      CursorLine = { bg = "highlight_low" },
      CursorLineNr = { fg = "gold" },

      -- Statusline
      StatusLine = { fg = "love", bg = "love", blend = 10 },
      StatusLineNC = { fg = "subtle", bg = "surface" },

      -- Which-key
      WhichKeyFloat = { bg = "surface" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    if not require("core.theme").read_base46_theme() then
      vim.cmd.colorscheme("rose-pine")
    end
  end,
}
