local M = {}

function M.setup()
  local dap = require "dap"
  local dapui = require "dapui"

  dap.defaults.fallback.focus_terminal = false
  dap.defaults.fallback.terminal_win_cmd = "botright 15split new"

  vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignOk", linehl = "Visual" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticSignError" })

  dap.listeners.after.event_initialized.dapui_config = function()
    dapui.open()
  end

  -- Keep the UI open after termination so a crashed/exited server does not
  -- rearrange the editor underneath you. Toggle it manually with <leader>du.
  dap.listeners.before.event_terminated.dapui_config = nil
  dap.listeners.before.event_exited.dapui_config = nil
end

return M
