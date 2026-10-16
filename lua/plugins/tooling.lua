-- ─── Tooling — reproducible external developer tools ─────────
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsInstallSync", "MasonToolsUpdateSync", "MasonToolsClean" },
    -- Set NVIM_SKIP_MASON_INSTALL=1 (e.g. in CI or headless verification) to
    -- skip the startup tool-install check.
    cond = function()
      return vim.env.NVIM_SKIP_MASON_INSTALL == nil
    end,
    opts = {
      ensure_installed = {
        -- Formatters and linters used by conform.nvim / gopls.
        "stylua", "ruff", "shfmt", "taplo", "nixfmt",
        "prettier", "clang-format",
        "gofumpt", "goimports", "golangci-lint",
        -- Debug adapters for Go and Rust/C/C++.
        "delve", "codelldb", "debugpy",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
  },
}
