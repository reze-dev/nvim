-- ─── Global Keymaps ───────────────────────────────────────────
-- Plugin-specific keymaps live in their respective plugin files.
local map = vim.keymap.set

-- Better escape
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save & quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Clear search highlights
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Better window navigation (overridden by tmux-navigator when in tmux)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force close buffer" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

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

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Lazy plugin manager
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
