-- ─── System Environment & PATH ───────────────────────────────
-- Prepend Mason bin (~/.local/share/nvim/mason/bin), ~/go/bin, ~/.cargo/bin,
-- and ~/.local/bin (user-installed CLI tools such as the tree-sitter CLI).
local home = vim.env.HOME or vim.fn.expand("~")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local go_bin = home .. "/go/bin"
local cargo_bin = home .. "/.cargo/bin"
local local_bin = home .. "/.local/bin"

local path_prepend = {}
local function maybe_prepend(dir)
  if dir and dir ~= "" and vim.uv.fs_stat(dir) then
    if not string.find(vim.env.PATH or "", dir, 1, true) then
      path_prepend[#path_prepend + 1] = dir
    end
  end
end

maybe_prepend(mason_bin)
maybe_prepend(go_bin)
maybe_prepend(cargo_bin)
maybe_prepend(local_bin)

if #path_prepend > 0 then
  vim.env.PATH = table.concat(path_prepend, ":") .. ":" .. (vim.env.PATH or "")
end

-- ─── Editor Options ───────────────────────────────────────────
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Tabs & indentation (treesitter + filetype indent own this; smartindent fights them)
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = false
opt.autoindent = true
opt.breakindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.showmode = false -- lualine handles this
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.winborder = "rounded" -- Neovim 0.11+: default border for all floats
opt.conceallevel = 0
opt.cmdheight = 1
opt.laststatus = 3 -- global statusline
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "v", foldsep = " ", foldclose = ">" }
opt.shortmess:append("sI") -- disable nvim intro

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.linebreak = true -- only takes effect when wrap is on (see WrapSpell autocmd)
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
local undo_dir = vim.fn.stdpath("data") .. "/undo"
opt.undodir = undo_dir
if not vim.uv.fs_stat(undo_dir) then
  vim.fn.mkdir(undo_dir, "p")
end
opt.updatetime = 200
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.inccommand = "split"
opt.jumpoptions = "view"
opt.smoothscroll = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.diffopt:append("linematch:60")
opt.sessionoptions:append("globals")

-- Folding (treesitter-based; guarded per-buffer in autocmds for big files)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99

-- Shell — fish causes issues with some plugins on NixOS
opt.shell = "bash"

-- Disable some builtin providers we don't need
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
