-- ─── Global Keymaps ───────────────────────────────────────────
-- Plugin-specific keymaps live in their respective plugin files.
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better escape
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>confirm qa<cr>", { desc = "Quit all (confirm)" })

vim.api.nvim_create_user_command("Build", function() require("core.build").run() end, { desc = "Build current project" })
map("n", "<leader>cb", "<cmd>Build<cr>", { desc = "Build project" })

-- Clear search highlights (also <Esc> in normal mode)
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Better window navigation (overridden by tmux-navigator when in tmux)
-- NOTE: core maps removed to avoid double-registration; vim-tmux-navigator
-- owns <C-h/j/k/l> now (see plugins/tmux-navigator.lua).
-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Window splits (QoL)
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>qw", "<cmd>close<cr>", { desc = "Close window" })

-- Buffer navigation (<S-h>/<S-l> shadow H/L top/bottom — intentional)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Close buffer, keep split" })
map("n", "<leader>bD", function() Snacks.bufdelete({ force = true }) end, { desc = "Force close buffer, keep split" })

-- Move lines up/down in visual mode
map("v", "J", ":<C-u>m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":<C-u>m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Keep search terms centered
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Paste without losing register content
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- Delete without yanking (visual mode only, keeping normal <leader>d free for DAP)
map("x", "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Better terminal navigation
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move to left window (terminal)" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move to lower window (terminal)" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move to upper window (terminal)" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move to right window (terminal)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quickfix navigation (pcall: empty list otherwise errors E42/E553)
map("n", "]q", function()
  local ok = pcall(vim.cmd, "cnext")
  if ok then
    vim.cmd("normal! zz")
  end
end, { desc = "Next quickfix item" })
map("n", "[q", function()
  local ok = pcall(vim.cmd, "cprev")
  if ok then
    vim.cmd("normal! zz")
  end
end, { desc = "Previous quickfix item" })

-- Select all (kept off <C-a> to preserve increment; use g<C-a> for increment visual)
map("n", "<leader><C-a>", "ggVG", { desc = "Select all" })

-- Lazy plugin manager
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
