-- ─── Which-Key — Keybinding Guide ─────────────────────────────
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      mappings = true,
      rules = {},
    },
    spec = {
      -- Top-level group prefixes
      { "<leader>f", group = "Find", icon = "" },
      { "<leader>b", group = "Buffer", icon = "󰓩 " },
      { "<leader>l", group = "LSP", icon = "" },
      { "<leader>c", group = "Code", icon = "󰅩 " },
      { "<leader>r", group = "Rust", icon = "󱘗 " },
      { "<leader>G", group = "Go", icon = "" },
      { "<leader>t", group = "Test", icon = "󰙨 " },
      { "<leader>d", group = "Debug", icon = "" },
      { "<leader>u", group = "UI/Toggles", icon = "󱄄 " },
      { "<leader>g", group = "Git", icon = "󰊢 " },
      { "<leader>x", group = "Trouble/Diagnostics", icon = "󰅙 " },
      { "<leader>s", group = "Search/Noice", icon = "󰎟 " },
      { "<leader>sn", group = "Noice", icon = "󰎟 " },
      { "<leader>q", group = "Session", icon = "󰩈 " },
      -- Leaf mappings with icons (oil/harpoon live here, not groups)
      { "<leader>e", icon = "󰙅 " },
      { "<leader>a", icon = "󰛢 " },
      { "<leader>w", icon = "󰆓 " },
      { "<leader>L", icon = "󰒲 " },
      -- Bracket groups
      { "[h", desc = "Harpoon prev", icon = "󰛢 " },
      { "]h", desc = "Harpoon next", icon = "󰛢 " },
      { "[b", desc = "Prev buffer", icon = "󰓩 " },
      { "]b", desc = "Next buffer", icon = "󰓩 " },
      { "[t", desc = "Prev TODO", icon = "󰍡 " },
      { "]t", desc = "Next TODO", icon = "󰍡 " },
      { "[T", desc = "Prev failed test", icon = "󰙨 " },
      { "]T", desc = "Next failed test", icon = "󰙨 " },
      { "[d", desc = "Prev diagnostic", icon = "󰅙 " },
      { "]d", desc = "Next diagnostic", icon = "󰅙 " },
      { "[e", desc = "Prev error", icon = " " },
      { "]e", desc = "Next error", icon = " " },
      { "[g", desc = "Prev git hunk", icon = "󰊢 " },
      { "]g", desc = "Next git hunk", icon = "󰊢 " },
      { "[q", desc = "Prev quickfix", icon = "󰁨 " },
      { "]q", desc = "Next quickfix", icon = "󰁨 " },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
    },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    show_help = true,
    show_keys = true,
    triggers = {
      { "<auto>", mode = "nxsot" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps (which-key)",
    },
  },
}
