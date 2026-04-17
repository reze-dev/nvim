return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    cmd = {
      "FlutterRun",
      "FlutterQuit",
      "FlutterOutlineToggle",
      "FlutterDevices",
      "FlutterEmulators",
      "FlutterReload",
      "FlutterRestart",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- for better UI
    },
    config = function()
      local on_attach = require("nvchad.configs.lspconfig").on_attach
      local capabilities = require("nvchad.configs.lspconfig").capabilities

      require("flutter-tools").setup {
        ui = {
          border = "rounded",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        lsp = {
          on_attach = on_attach,
          capabilities = capabilities,
          color = {
            enabled = true,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(paths)
            local dap = require("dap")
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                dartSdkPath = paths.dartSdk,
                flutterSdkPath = paths.flutterSdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
      }
    end,
  },
}
