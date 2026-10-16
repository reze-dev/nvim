-- ─── Go Support ───────────────────────────────────────────────
return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
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
        -- Testing (neotest-golang is the primary runner; GoTest is the fallback)
        test_runner = "go",
        run_in_floaterm = false,
        -- DAP — owned by dap.lua (delve adapter + configurations).
        dap_debug = false,
        -- Tags
        tag_transform = "snakecase",
        tag_options = "json=omitempty",
        -- Misc
        verbose = false,
        log_path = vim.fn.stdpath("cache") .. "/gonvim.log",
        icons = { breakpoint = "\u{F057} ", currentpos = "▶ " },
      })

      -- Go-specific keymaps
      local go_keys = vim.api.nvim_create_augroup("GoKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = go_keys,
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
          map("<leader>Gd", function() require("dap").continue() end, "Start debugger")
          map("<leader>GD", function() require("dap").terminate() end, "Stop debugger")
          map("<leader>Gl", "<cmd>GoLint<cr>", "Lint")
          map("<leader>Gv", "<cmd>GoVet<cr>", "Vet")
          map("<leader>Gg", "<cmd>GoGenerate<cr>", "Go generate")
          map("<leader>Gm", "<cmd>GoModTidy<cr>", "Go mod tidy")
        end,
      })
    end,
  },
}
