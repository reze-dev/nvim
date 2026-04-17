return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = function()
        local nvlsp = require "nvchad.configs.lspconfig"
        local cfg = require "rustaceanvim.config"
        local extension_path = vim.fs.joinpath(vim.fn.expand "$MASON", "packages", "codelldb", "extension")
        local codelldb_path = vim.fs.joinpath(extension_path, "adapter", "codelldb")
        local liblldb_path = vim.fs.joinpath(extension_path, "lldb", "lib", "liblldb.so")
        local dap = { autoload_configurations = true }

        if vim.fn.executable(codelldb_path) == 1 and vim.uv.fs_stat(liblldb_path) then
          dap.adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
          dap.adapter.name = "codelldb"
          dap.configuration = {
            name = "Rust debug",
            type = "codelldb",
            request = "launch",
            stopOnEntry = false,
            sourceLanguages = { "rust" },
          }
        end

        return {
          server = {
            on_attach = nvlsp.on_attach,
            capabilities = nvlsp.capabilities,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                },
                check = {
                  command = "clippy",
                },
              },
            },
          },
          dap = dap,
        }
      end
    end,
    keys = {
      {
        "<Leader>rd",
        "<cmd>RustLsp debuggables<CR>",
        desc = "Rust debug target",
        ft = "rust",
      },
      {
        "<Leader>rr",
        "<cmd>RustLsp runnables<CR>",
        desc = "Rust run target",
        ft = "rust",
      },
      {
        "<Leader>rt",
        "<cmd>RustLsp testables<CR>",
        desc = "Rust test target",
        ft = "rust",
      },
      {
        "<Leader>re",
        "<cmd>RustLsp explainError<CR>",
        desc = "Rust explain error",
        ft = "rust",
      },
      {
        "<leader>ca",
        function()
          vim.cmd.RustLsp "codeAction"
        end,
        desc = "Code Action",
        ft = "rust",
      },
    },
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            -- same on_attach as other servers
          end,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          crates = {
            enabled = true,
            max_results = 8,
            min_chars = 3,
          },
        },
      }
    end,
  },
}
