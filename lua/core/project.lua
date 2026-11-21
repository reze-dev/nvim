local M = {}

local markers = { "Cargo.toml", "go.mod", "go.work", "build.zig", "CMakeLists.txt" }
local preferred = {
  rust = "Cargo.toml", go = "go.mod", gomod = "go.mod", gowork = "go.work",
  zig = "build.zig", c = "CMakeLists.txt", cpp = "CMakeLists.txt", cmake = "CMakeLists.txt",
}

-- Prefer the nearest manifest. Filetype breaks ties in mixed-language projects.
function M.resolve()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  local git_root = vim.fs.root(dir, ".git")
  local best = preferred[vim.bo.filetype]
  local current = dir
  while current do
    if best and vim.uv.fs_stat(vim.fs.joinpath(current, best)) then
      return current, best
    end
    for _, name in ipairs(markers) do
      if vim.uv.fs_stat(vim.fs.joinpath(current, name)) then
        return current, name
      end
    end
    local parent = vim.fs.dirname(current)
    if current == git_root or parent == current then break end
    current = parent
  end

  local workspace
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local root = client.config.root_dir
    if type(root) == "string" and vim.fs.relpath(root, dir) and (not workspace or #root > #workspace) then
      workspace = root
    end
  end
  return workspace or git_root or dir
end

-- Cargo reports paths and places build artifacts relative to its workspace.
function M.workspace(root, manifest)
  if manifest == "Cargo.toml" and vim.fn.executable("cargo") == 1 then
    local result = vim.system({ "cargo", "locate-project", "--workspace", "--message-format", "plain" },
      { cwd = root, text = true }):wait()
    if result.code == 0 then return vim.fs.dirname(vim.trim(result.stdout)) end
  end
  return root
end

function M.root()
  return M.workspace(M.resolve())
end

return M
