-- ─── Tooling — reproducible external developer tools ─────────
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Formatters and linters used by conform.nvim / gopls.
        "stylua", "ruff", "shfmt", "taplo", "nixfmt",
        "gofumpt", "goimports", "golangci-lint",
        -- Debug adapters for Go and Rust/C/C++.
        "delve", "codelldb",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
  },
}
