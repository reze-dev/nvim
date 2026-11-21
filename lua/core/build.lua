local M = {}
local running = {}

local commands = {
  ["Cargo.toml"] = { "cargo", "build", "--message-format=short" },
  ["go.mod"] = { "go", "build", "./..." },
  ["go.work"] = { "go", "build", "all" },
  ["build.zig"] = { "zig", "build" },
}

local function cmake_dir(root)
  if vim.b.cmake_build_dir then
    local path = vim.b.cmake_build_dir
    return vim.fn.isabsolutepath(path) == 1 and path or vim.fs.joinpath(root, path)
  end
  -- A subdirectory can have its own CMakeLists.txt within a configured project.
  local boundary = vim.fs.root(root, ".git")
  local source = root
  while source do
    if vim.uv.fs_stat(source .. "/CMakeLists.txt") then
      for _, name in ipairs({ "build", "cmake-build-debug", "cmake-build-release", "." }) do
        local path = vim.fs.joinpath(source, name)
        if vim.uv.fs_stat(path .. "/CMakeCache.txt") then return path end
      end
    end
    if source == boundary or source == vim.fs.dirname(source) then break end
    source = vim.fs.dirname(source)
  end
end

local function finish(id, directory, title, tab, result)
  -- Give errorformat the build directory so relative compiler paths resolve
  -- correctly even if the user switched windows before the process finished.
  local lines = { "Build directory: " .. directory }
  for _, stream in ipairs({ result.stdout or "", result.stderr or "" }) do
    vim.list_extend(lines, vim.split(stream, "\n", { plain = true, trimempty = true }))
  end
  local ok = result.code == 0 and result.signal == 0
  local status = ok and "succeeded" or "failed"
  if vim.fn.getqflist({ id = id }).id == id then
    vim.fn.setqflist({}, "r", {
      id = id, title = title .. " (" .. status .. ")", lines = lines,
      efm = "%-DBuild directory: %f,%f:%l:%c: %m,%f:%l: %m," .. vim.o.errorformat,
    })
    if not ok and vim.api.nvim_get_current_tabpage() == tab and vim.fn.getqflist({ id = 0 }).id == id then
      vim.cmd.copen()
    end
  end
  vim.notify(title .. " " .. status, ok and vim.log.levels.INFO or vim.log.levels.ERROR)
end

function M.run()
  local project = require("core.project")
  local root, manifest = project.resolve()
  local cmd = commands[manifest]
  if manifest == "CMakeLists.txt" then
    local dir = cmake_dir(root)
    if not dir or not vim.uv.fs_stat(dir .. "/CMakeCache.txt") then
      vim.notify("Configure a CMake build directory first (cmake -S . -B build), or set b:cmake_build_dir.", vim.log.levels.WARN)
      return
    end
    root = vim.fs.normalize(dir)
    cmd = { "cmake", "--build", "." }
  end
  if not cmd then
    vim.notify("No Cargo, Go, Zig or CMake project found for this buffer.", vim.log.levels.WARN)
    return
  end
  if running[root] then
    vim.notify("Build already running in " .. root)
    return
  end
  if vim.fn.executable(cmd[1]) == 0 then
    vim.notify("Build tool missing from PATH: " .. cmd[1], vim.log.levels.ERROR)
    return
  end
  local title = table.concat(cmd, " ") .. " · " .. root
  vim.fn.setqflist({}, " ", { title = title .. " (running)" })
  local id = vim.fn.getqflist({ id = 0 }).id
  local tab = vim.api.nvim_get_current_tabpage()
  local diagnostic_dir = project.workspace(root, manifest)
  local function on_exit(result)
    running[root] = nil
    finish(id, diagnostic_dir, title, tab, result)
  end
  running[root] = true
  local ok, err = pcall(vim.system, cmd, { cwd = root, text = true, env = { NO_COLOR = "1" } },
    vim.schedule_wrap(on_exit))
  if not ok then
    on_exit({ code = 1, stderr = tostring(err) })
  end
end

return M
