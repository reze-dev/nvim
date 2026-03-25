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

-- Flutter tools mappings
map("n", "<leader>fr", "<cmd>FlutterRun<CR>", { desc = "Flutter Run" })
map("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter Quit" })
map("n", "<leader>fo", "<cmd>FlutterOutlineToggle<CR>", { desc = "Flutter Outline" })
map("n", "<leader>fd", "<cmd>FlutterDevices<CR>", { desc = "Flutter Devices" })
map("n", "<leader>fe", "<cmd>FlutterEmulators<CR>", { desc = "Flutter Emulators" })
map("n", "<leader>fl", "<cmd>FlutterReload<CR>", { desc = "Flutter Hot Reload" })
map("n", "<leader>fR", "<cmd>FlutterRestart<CR>", { desc = "Flutter Hot Restart" })

