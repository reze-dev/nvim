require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set("n", "<leader>ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Vim Tmux Navigator
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })


