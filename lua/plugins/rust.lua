return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function()
      local mason_registry = require "mason-registry"
      local codelldb = vim.fn.expand "$MASON/packages/codelldb"
      local extension_path = codelldb .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      local on_attach = require("nvchad.configs.lspconfig").on_attach
      local capabilities = require("nvchad.configs.lspconfig").capabilities
      local cfg = require "rustaceanvim.config"

      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
    keys = {
      {
        "<Leader>drt",
        "<cmd>RustLsp testables<CR>",
        desc = "Rust Debugger testables",
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
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
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
