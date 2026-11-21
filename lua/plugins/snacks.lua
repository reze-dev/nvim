-- ─── Snacks.nvim — Dashboard, Picker, Explorer & Utilities ───
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- ── Dashboard ──
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          -- NOTE: every icon must be exactly 1 cell wide (+ 1 trailing space
          -- = width 2, which is what snacks declares for the icon field).
          -- , 󰒲 and  render double-width in some terminal fonts and stagger
          -- their rows by 1 cell, so we use guaranteed single-cell glyphs.
          { icon = "\u{F0F6} ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "󰱼 ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = "\u{F12E} ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = "\u{F011} ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { pane = 1, section = "header" },
        { pane = 1, section = "startup", padding = 1 },
        { pane = 2, section = "keys", gap = 1, padding = 1 },
      },
    },

    -- ── Picker (replaces telescope.nvim) — fast, no plenary, native fzf ──
    picker = { enabled = true },
    explorer = { enabled = true },
    input = { enabled = true },
    scope = { enabled = true },
    lazygit = { enabled = true },

    -- ── Notifier ── handled by noice.nvim + nvim-notify (see ui.lua), so the
    -- snacks notifier stays off to avoid two frontends fighting over vim.notify.
    notifier = { enabled = false },

    -- ── Quick file ── (fast file opening)
    quickfile = { enabled = true },

    -- ── Status column ──
    statuscolumn = { enabled = true },

    -- ── Words ── handled by vim-illuminate (see ui.lua)
    words = { enabled = false },
  },
  keys = {
    { "<C-/>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
    { "<leader>f/", function() Snacks.picker.lines() end, desc = "Find line in buffer" },
    -- Find & picker (ex-telescope bindings, now Snacks)
    { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Find word under cursor" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
    { "<leader>gt", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader><leader>", function() Snacks.picker.resume() end, desc = "Resume last search" },
    -- Explorer (Oil stays primary on <leader>e; this is the sidebar alt)
    { "<leader>E", function() Snacks.explorer() end, desc = "Explorer (Snacks)" },
    { "<leader>un", function()
      local ok, noice = pcall(require, "noice")
      if ok then
        noice.cmd("dismiss")
      end
    end, desc = "Dismiss all notifications" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
  },
}
