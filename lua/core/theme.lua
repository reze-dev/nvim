local M = {}

M.base46_state_file = vim.fn.stdpath("state") .. "/base46-theme"

function M.read_base46_theme()
  if vim.fn.filereadable(M.base46_state_file) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(M.base46_state_file)
  local theme = lines[1]
  return theme and theme ~= "" and theme or nil
end

function M.write_base46_theme(theme)
  vim.fn.mkdir(vim.fn.fnamemodify(M.base46_state_file, ":h"), "p")
  vim.fn.writefile({ theme }, M.base46_state_file)
end

return M
