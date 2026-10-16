-- ─── System Environment & PATH ───────────────────────────────
-- Prepend Mason bin (~/.local/share/nvim/mason/bin), ~/go/bin, ~/.cargo/bin,
-- and ~/.local/bin (user-installed CLI tools such as the tree-sitter CLI).
local home = vim.env.HOME or vim.fn.expand("~")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local go_bin = home .. "/go/bin"
local cargo_bin = home .. "/.cargo/bin"
local local_bin = home .. "/.local/bin"

local path_prepend = { mason_bin, go_bin, cargo_bin }
if vim.uv.fs_stat(local_bin) then
  path_prepend[#path_prepend + 1] = local_bin
end

vim.env.PATH = table.concat(path_prepend, ":") .. ":" .. (vim.env.PATH or "")

-- ─── Editor Options ───────────────────────────────────────────
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

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
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
local undo_dir = vim.fn.stdpath("data") .. "/undo"
opt.undodir = undo_dir
vim.fn.mkdir(undo_dir, "p")
opt.updatetime = 200
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.inccommand = "split"
opt.jumpoptions = "view"
opt.smoothscroll = true

-- Folding (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Shell — fish causes issues with some plugins on NixOS
opt.shell = "bash"

-- Disable some builtin providers we don't need
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
