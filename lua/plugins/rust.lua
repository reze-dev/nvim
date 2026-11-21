-- ─── Rustaceanvim — Rust IDE ──────────────────────────────────
-- NOTE: This is a filetype plugin. Do NOT configure rust-analyzer
-- through nvim-lspconfig — rustaceanvim handles everything.
return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false, -- rustaceanvim loads its server through the Rust ftplugin.
  init = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end

    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
      server = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Common LSP keymaps are handled by the LspAttach autocommand in lsp.lua
          -- Here we only add Rust-specific keymaps
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
          end

          map("<leader>re", "<cmd>RustLsp expandMacro<cr>", "Expand macro")
          map("<leader>rc", "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml")
          map("<leader>rp", "<cmd>RustLsp parentModule<cr>", "Parent module")
          map("<leader>rd", "<cmd>RustLsp renderDiagnostic<cr>", "Render diagnostic")
          map("<leader>rr", "<cmd>RustLsp runnables<cr>", "Runnables")
          map("<leader>rt", "<cmd>RustLsp testables<cr>", "Testables")
          map("<leader>rm", "<cmd>RustLsp rebuildProcMacros<cr>", "Rebuild proc macros")
          map("<leader>rk", "<cmd>RustLsp moveItem up<cr>", "Move item up")
          map("<leader>rj", "<cmd>RustLsp moveItem down<cr>", "Move item down")
          map("<leader>ra", "<cmd>RustLsp codeAction<cr>", "Code action (rust)")
          map("<leader>rh", "<cmd>RustLsp hover actions<cr>", "Hover actions")
          map("<leader>rJ", "<cmd>RustLsp joinLines<cr>", "Join lines (Rust)")

          -- Debugging
          map("<leader>rD", "<cmd>RustLsp debuggables<cr>", "Debuggables")
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
              buildScripts = { enable = true },
            },
            checkOnSave = true,
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            inlayHints = {
              bindingModeHints = { enable = false },
              chainingHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 25 },
              closureReturnTypeHints = { enable = "with_block" },
              lifetimeElisionHints = { enable = "never" },
              maxLength = 25,
              parameterHints = { enable = true },
              reborrowHints = { enable = "never" },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
    }
  end,
}
