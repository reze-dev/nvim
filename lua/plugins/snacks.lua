-- ─── Snacks.nvim — Dashboard & Utilities ──────────────────────
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
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "󰱼 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
                                                                              
                                                                              
                                                                           
             ████ ██████           █████      ██                     
            ███████████             █████                             
            █████████ ███████████████████ ███   ███████████   
           █████████  ███    █████████████ █████ ██████████████   
          █████████ ██████████ █████████ █████ █████ ████ █████   
        ███████████ ███    ███ █████████ █████ █████ ████ █████  
       ██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                             
                                                                                     
                                                                              
                                                                            
                                                                              
       ]],
      },
      sections = {
        { pane = 1, section = "header", padding = 2 },
        { pane = 1, section = "startup", padding = 1 },
        { pane = 2, section = "keys", gap = 1, padding = 1 },
      },
    },

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
    { "<leader>un", function() require("noice").cmd("dismiss") end, desc = "Dismiss all notifications" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
  },
}
