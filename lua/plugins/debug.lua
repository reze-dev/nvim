return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      { "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", desc = "Debugger step into" },
      { "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", desc = "Debugger step over" },
      { "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", desc = "Debugger step out" },
      { "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", desc = "Debugger continue" },
      { "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Debugger toggle breakpoint" },
      {
        "<Leader>dd",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Debugger set conditional breakpoint",
      },
      { "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", desc = "Debugger reset" },
      { "<Leader>drl", "<cmd>lua require'dap'.run_last()<CR>", desc = "Debugger run last" },
      {
        "<Leader>ds",
        function()
          local widgets = require "dap.ui.widgets"
          local sidebar = widgets.sidebar(widgets.scopes)
          sidebar.open()
        end,
        desc = "Debugger sidebar open",
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
}
