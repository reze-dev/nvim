-- ─── LSP Configuration (Neovim 0.12+ native API) ─────────────
return {
  -- nvim-lspconfig provides the default configs catalog
  {
    "neovim/nvim-lspconfig",
    lazy = true, -- loaded as a catalog, not via setup()
  },

  -- Mason for LSP server management
  -- NOTE: On NixOS, Mason-installed binaries may fail due to glibc.
  --       If so, install LSPs via nix and remove from ensure_installed.
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "taplo", -- TOML
        -- NOTE: rust-analyzer is NOT here — handled by rustaceanvim
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- ── Diagnostic configuration ──
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- ── LspAttach autocommand (replaces on_attach) ──
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
          map("<leader>li", vim.lsp.buf.incoming_calls, "Incoming calls")
          map("<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing calls")

          -- Info
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<C-S-k>", vim.lsp.buf.signature_help, "Signature help")
          map("<C-S-k>", vim.lsp.buf.signature_help, "Signature help", "i")

          -- Actions
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", "v")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

          -- Diagnostics
          map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
          map("[e", function()
            vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
          end, "Previous error")
          map("]e", function()
            vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
          end, "Next error")

          -- Workspace
          map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("<leader>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")

          -- Inlay hints (Neovim 0.10+)
          if client:supports_method("textDocument/inlayHint", bufnr) then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            map("<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "Toggle inlay hints")
          end

          -- Codelens
          if client:supports_method("textDocument/codeLens", bufnr) then
            map("<leader>ll", vim.lsp.codelens.run, "Run codelens")
            map("<leader>lL", vim.lsp.codelens.refresh, "Refresh codelens")
          end

          if client:supports_method("textDocument/documentHighlight", bufnr) then
            local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- ── Capabilities (blink.cmp integration) ──
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Clangd capabilities with UTF-16/UTF-8 offset encoding
      local clangd_capabilities = vim.deepcopy(capabilities)
      clangd_capabilities.offsetEncoding = { "utf-16", "utf-8" }

      -- ── Server configurations using vim.lsp.config (Neovim 0.12+) ──

      -- Clangd (C/C++)
      vim.lsp.config("clangd", {
        capabilities = clangd_capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--pch-storage=memory",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      -- Python — basedpyright
      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              autoImportCompletions = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedVariable = "information",
              },
            },
          },
        },
      })

      -- Go — gopls
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
            semanticTokens = true,
          },
        },
      })

      -- TypeScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      -- HTML
      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      -- CSS
      vim.lsp.config("cssls", {
        capabilities = capabilities,
      })

      -- JSON
      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      -- YAML
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {},
            validate = true,
            format = { enable = true },
          },
        },
      })

      -- TOML
      vim.lsp.config("taplo", {
        capabilities = capabilities,
      })

      -- Enable all servers
      vim.lsp.enable({
        "clangd",
        "lua_ls",
        "basedpyright",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "taplo",
      })
    end,
  },
}
