return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function()
      require("configs.dap").setup()
    end,
    keys = {
      {
        "<Leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Debugger continue",
      },
      {
        "<Leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Debugger step over",
      },
      {
        "<Leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Debugger step into",
      },
      {
        "<Leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Debugger step out",
      },
      {
        "<Leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debugger toggle breakpoint",
      },
      {
        "<Leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Debugger set conditional breakpoint",
      },
      {
        "<Leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Debugger pause",
      },
      {
        "<Leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Debugger terminate",
      },
      {
        "<Leader>dL",
        function()
          require("dap").run_last()
        end,
        desc = "Debugger run last",
      },
      {
        "<Leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debugger toggle UI",
      },
      {
        "<Leader>dR",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Debugger toggle REPL",
      },
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
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {
      force_buffers = false,
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.35 },
            { id = "stacks", size = 0.25 },
            { id = "breakpoints", size = 0.20 },
            { id = "watches", size = 0.20 },
          },
          size = 42,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 12,
          position = "bottom",
        },
      },
      floating = {
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
}
