local M = {}

M.base46_state_file = vim.fn.stdpath("state") .. "/base46-theme"

function M.read_base46_theme()
  if vim.fn.filereadable(M.base46_state_file) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(M.base46_state_file)
  local theme = lines[1]
  if type(theme) == "string" then
    theme = vim.trim(theme)
  end
  return theme and theme ~= "" and theme or nil
end

function M.write_base46_theme(theme)
  if type(theme) ~= "string" or theme == "" then
    return false
  end
  local dir = vim.fn.fnamemodify(M.base46_state_file, ":h")
  if not vim.uv.fs_stat(dir) then
    vim.fn.mkdir(dir, "p")
  end
  return vim.fn.writefile({ theme }, M.base46_state_file) == 0
end

return M
