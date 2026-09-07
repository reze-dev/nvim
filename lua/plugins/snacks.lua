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

    -- ── Notifier ──
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },

    -- ── Quick file ── (fast file opening)
    quickfile = { enabled = true },

    -- ── Status column ──
    statuscolumn = { enabled = true },

    -- ── Words ── (highlight/navigate references)
    words = { enabled = true },

    -- ── Styles ──
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
  },
  keys = {
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
  },
}
