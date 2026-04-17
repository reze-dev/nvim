local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    rust = { "rustfmt", lsp_format = "fallback" },
    go = { "goimports", "gofumpt", "golines" },
    css = { "prettier" },
    html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

return options
