-- Run inside a fresh Neovim instance with the normal configuration loaded.
local function check()
  require("lazy").load({ plugins = { "neotest", "harpoon", "nvim-dap" } })
  local adapters = {}
  for _, adapter in ipairs(require("neotest.config").adapters) do
    assert(type(adapter.discover_positions) == "function", adapter.name)
    adapters[adapter.name] = true
  end
  for _, name in ipairs({ "rustaceanvim", "neotest-golang", "neotest-gtest" }) do
    assert(adapters[name], "Missing Neotest adapter: " .. name)
  end

  local list = require("harpoon"):list()
  assert(type(list:length()) == "number", "Harpoon list unavailable")
  vim.cmd.DapViewOpen()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dap-view" then
      vim.cmd.DapViewClose()
      assert(vim.v.errmsg == "", vim.v.errmsg)
      return
    end
  end
  error("DAP View did not open")
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
print("Neotest, Harpoon and DAP View passed")
vim.cmd("qa!")
