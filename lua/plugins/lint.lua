-- ─── nvim-lint — Asynchronous Linting Engine ─────────────────────
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    cmd = "Lint",
    keys = {
      { "<leader>cl", "<cmd>Lint<cr>", desc = "Lint current buffer" },
    },
    opts = {
      -- NOTE: c/cpp intentionally omitted — clangd --clang-tidy (lsp.lua)
      -- already reports them. Running nvim-lint clang-tidy too = duplicates.
      linters_by_ft = {
        go = { "golangci-lint" },
        python = { "ruff" },
        yaml = { "yamllint" },
        ["yaml.docker-compose"] = { "yamllint" },
        dockerfile = { "hadolint" },
        terraform = { "tflint" },
        ["terraform-vars"] = { "tflint" },
        hcl = { "tflint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      -- nvim-lint module names have no hyphens; our ft table uses hyphens.
      if lint.linters.clangtidy then
        lint.linters["clang-tidy"] = lint.linters.clangtidy
      end
      if lint.linters.golangcilint then
        lint.linters["golangci-lint"] = lint.linters.golangcilint
      end

      lint.linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })

      local save_only = { ["golangci-lint"] = true, tflint = true }
      local function run_lint(event)
        local bufnr = vim.api.nvim_get_current_buf()
        if event and vim.b[bufnr].bigfile then
          return
        end
        local ft = vim.bo[bufnr].filetype
        if not ft or ft == "" then
          return
        end
        local linters = lint.linters_by_ft[ft] or {}
        if type(linters) ~= "table" or #linters == 0 then
          return
        end

        local valid_linters = {}
        for _, name in ipairs(linters) do
          local enabled = not event or event == "BufWritePost" or not save_only[name]
          local linter = enabled and lint.linters[name]
          if linter then
            local cmd = type(linter) == "table" and linter.cmd or name
            if type(cmd) == "function" then
              cmd = cmd()
            end
            -- cmd can be a string or { cmd, args... } list
            if type(cmd) == "table" then
              cmd = cmd[1]
            end
            if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
              table.insert(valid_linters, name)
            end
          end
        end

        if #valid_linters > 0 then
          lint.try_lint(valid_linters)
        end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function(ev)
          vim.api.nvim_buf_call(ev.buf, function() run_lint(ev.event) end)
        end,
      })

      -- User command for manual linting (<leader>cl is declared in keys above)
      vim.api.nvim_create_user_command("Lint", function()
        run_lint()
      end, { desc = "Trigger linting for current buffer" })
    end,
  },
}
