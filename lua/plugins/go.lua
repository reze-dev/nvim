-- ─── Go Support ───────────────────────────────────────────────
return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        -- Disable LSP here — we configure gopls in lsp.lua
        lsp_cfg = false,
        lsp_on_attach = false,
        -- Formatting is owned by conform.nvim (one formatter on save).
        gofmt = "gofumpt",
        goimports = "gopls",
        -- Linting
        linter = "golangci-lint",
        -- Testing
        test_runner = "go",
        run_in_floaterm = true,
        floaterm = {
          position = "bottom",
          width = 0.98,
          height = 0.35,
        },
        -- DAP
        dap_debug = true,
        dap_debug_gui = true,
        -- Tags
        tag_transform = "snakecase",
        tag_options = "json=omitempty",
        -- Misc
        verbose = false,
        log_path = vim.fn.stdpath("cache") .. "/gonvim.log",
        icons = { breakpoint = "🔴", currentpos = "🏃" },
      })

      -- Go-specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go" },
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Go: " .. desc })
          end

          map("<leader>Gt", "<cmd>GoTest<cr>", "Run tests")
          map("<leader>Gf", "<cmd>GoTestFunc<cr>", "Test function")
          map("<leader>Gc", "<cmd>GoCoverage<cr>", "Toggle coverage")
          map("<leader>Ga", "<cmd>GoAddTag<cr>", "Add struct tags")
          map("<leader>Gr", "<cmd>GoRmTag<cr>", "Remove struct tags")
          map("<leader>Gi", "<cmd>GoImpl<cr>", "Implement interface")
          map("<leader>Ge", "<cmd>GoIfErr<cr>", "Generate if err")
          map("<leader>Gd", "<cmd>GoDebug<cr>", "Start debugger")
          map("<leader>GD", "<cmd>GoDebug -s<cr>", "Stop debugger")
          map("<leader>Gl", "<cmd>GoLint<cr>", "Lint")
          map("<leader>Gv", "<cmd>GoVet<cr>", "Vet")
          map("<leader>Gg", "<cmd>GoGenerate<cr>", "Go generate")
          map("<leader>Gm", "<cmd>GoModTidy<cr>", "Go mod tidy")
        end,
      })
    end,
  },
}
