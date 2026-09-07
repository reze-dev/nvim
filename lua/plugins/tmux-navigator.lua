-- ─── Vim-Tmux Navigator ───────────────────────────────────────
-- Matches tmux config: C-h/j/k/l for pane navigation
return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (tmux-aware)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (tmux-aware)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (tmux-aware)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (tmux-aware)" },
  },
  init = function()
    -- Disable default tmux navigator mappings, we set our own
    vim.g.tmux_navigator_no_mappings = 1
    -- Save on switch
    vim.g.tmux_navigator_save_on_switch = 2
    -- Disable when zoomed
    vim.g.tmux_navigator_disable_when_zoomed = 1
    -- Preserve zoom
    vim.g.tmux_navigator_preserve_zoom = 1
  end,
}
