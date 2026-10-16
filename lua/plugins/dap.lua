-- ─── DAP — Debug Adapter Protocol ─────────────────────────────
return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP: toggle UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "DAP: eval", mode = { "n", "v" } },
        },
        opts = {
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.35 },
                { id = "breakpoints", size = 0.15 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 40,
              position = "left",
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 0.25,
              position = "bottom",
            },
          },
          floating = {
            border = "rounded",
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
        },
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- Auto open/close dapui with pcall for non-blocking stability
          dap.listeners.after.event_initialized["dapui_config"] = function()
            pcall(function()
              dapui.open({})
            end)
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            pcall(function()
              dapui.close({})
            end)
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            pcall(function()
              dapui.close({})
            end)
          end
        end,
      },
      -- Virtual text
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          clear_on_continue = false,
          display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == "inline" then
              return " = " .. variable.value
            else
              return variable.name .. " = " .. variable.value
            end
          end,
          virt_text_pos = "eol",
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        },
      },
      -- Python debugger
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          -- Prefer Mason's debugpy venv (python inside works with debugpy);
          -- fall back to the system interpreter.
          local mason_venv =
            vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          require("dap-python").setup(
            vim.fn.filereadable(mason_venv) == 1 and mason_venv or vim.fn.exepath("python3")
          )
        end,
      },
      -- Mason DAP
      -- NOTE: ALL adapter packages (delve, codelldb, debugpy) are installed by
      --       mason-tool-installer (tooling.lua). This spec only registers
      --       adapters for packages already present — setting ensure_installed
      --       here would double-schedule installs and hit mason.nvim's
      --       "Package is already installing" assert.
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = false,
          ensure_installed = {},
          handlers = {},
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP: continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "DAP: run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP: step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP: step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP: step out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "DAP: pause" },
      { "<leader>dr", function() require("dap").restart() end, desc = "DAP: restart" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP: run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP: terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "DAP: widgets" },
    },
    config = function()
      local dap = require("dap")

      -- ── Custom signs ──
      vim.fn.sign_define("DapBreakpoint", { text = "\u{F057} ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "\u{F071} ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "\u{EB56} ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "\u{25C6} ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶ ", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })

      -- Highlight for the stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- ── CodeLLDB Discovery & Adapter ──
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      local codelldb_mason = mason_path .. "/extension/adapter/codelldb"
      local codelldb_cmd = "codelldb"

      if vim.fn.filereadable(codelldb_mason) == 1 or vim.fn.executable(codelldb_mason) == 1 then
        codelldb_cmd = codelldb_mason
      elseif vim.fn.executable("codelldb") == 1 then
        codelldb_cmd = vim.fn.exepath("codelldb")
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_cmd,
          args = { "--port", "${port}" },
        },
      }
      dap.adapters.lldb = dap.adapters.codelldb

      -- ── Executable Discovery & Selection Helper ──
      local function get_binary()
        local cwd = vim.fn.getcwd()
        local candidates = {}
        local seen = {}

        local search_dirs = {
          "target/debug",
          "target/release",
          "build",
          "build/bin",
          "bin",
          "out",
          "cmake-build-debug",
          "cmake-build-release",
        }

        local ignored_exts = {
          o = true, a = true, so = true, dylib = true, dll = true,
          d = true, rlib = true, rmeta = true, pdb = true,
          txt = true, log = true, cmake = true, json = true,
          ninja = true, lock = true,
        }

        local ignored_script_exts = {
          sh = true, bash = true, zsh = true, lua = true, py = true,
          pl = true, rb = true, js = true, ts = true, md = true,
        }

        for _, dir in ipairs(search_dirs) do
          local full_dir = cwd .. "/" .. dir
          if vim.fn.isdirectory(full_dir) == 1 then
            local files = vim.fn.glob(full_dir .. "/*", false, true)
            for _, file in ipairs(files) do
              if vim.fn.isdirectory(file) == 0 and vim.fn.executable(file) == 1 then
                local ext = vim.fn.fnamemodify(file, ":e"):lower()
                if not ignored_exts[ext] and not ignored_script_exts[ext] and not seen[file] then
                  seen[file] = true
                  table.insert(candidates, file)
                end
              end
            end
          end
        end

        -- Check root directory for executables
        local root_files = vim.fn.glob(cwd .. "/*", false, true)
        for _, file in ipairs(root_files) do
          if vim.fn.isdirectory(file) == 0 and vim.fn.executable(file) == 1 then
            local ext = vim.fn.fnamemodify(file, ":e"):lower()
            if not ignored_exts[ext] and not ignored_script_exts[ext] and not file:match("/%.") and not seen[file] then
              seen[file] = true
              table.insert(candidates, file)
            end
          end
        end

        local co = coroutine.running()
        if co and #candidates > 0 then
          local items = {}
          for _, c in ipairs(candidates) do
            table.insert(items, c)
          end
          table.insert(items, "Manually enter path...")

          vim.ui.select(items, {
            prompt = "Select executable: ",
            format_item = function(item)
              if item == "Manually enter path..." then
                return item
              end
              return vim.fn.fnamemodify(item, ":.")
            end,
          }, function(choice)
            if not choice then
              coroutine.resume(co, dap.ABORT)
            elseif choice == "Manually enter path..." then
              local manual = vim.fn.input("Path to executable: ", cwd .. "/", "file")
              coroutine.resume(co, manual ~= "" and manual or dap.ABORT)
            else
              coroutine.resume(co, choice)
            end
          end)
          return coroutine.yield()
        elseif #candidates == 1 and not co then
          return candidates[1]
        else
          local input = vim.fn.input("Path to executable: ", cwd .. "/", "file")
          if input == "" then
            return dap.ABORT or nil
          end
          return input
        end
      end

      -- ── C / C++ / Rust Launch Configurations ──
      local codelldb_configurations = {
        {
          name = "Launch Binary (Smart Picker)",
          type = "codelldb",
          request = "launch",
          program = get_binary,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Launch Binary with Arguments",
          type = "codelldb",
          request = "launch",
          program = get_binary,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            if args_str == "" then
              return {}
            end
            return vim.split(args_str, "%s+", { trimempty = true })
          end,
        },
        {
          name = "Attach to Process",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Load Core Dump",
          type = "codelldb",
          request = "attach",
          program = get_binary,
          coreDumpPath = function()
            local core_path = vim.fn.input("Path to core dump: ", vim.fn.getcwd() .. "/", "file")
            return core_path ~= "" and core_path or nil
          end,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.cpp = codelldb_configurations
      dap.configurations.c = codelldb_configurations
      dap.configurations.rust = codelldb_configurations

      -- ── Delve (Go) Adapter & Configurations ──
      local dlv_path = "dlv"
      local mason_dlv = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv"
      if vim.fn.filereadable(mason_dlv) == 1 or vim.fn.executable(mason_dlv) == 1 then
        dlv_path = mason_dlv
      elseif vim.fn.executable("dlv") == 1 then
        dlv_path = vim.fn.exepath("dlv")
      end

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = dlv_path,
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.adapters.go = dap.adapters.delve

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug (Smart Picker / Current File)",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Package",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "delve",
          name = "Debug with Arguments",
          request = "launch",
          program = "${file}",
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            if args_str == "" then
              return {}
            end
            return vim.split(args_str, "%s+", { trimempty = true })
          end,
        },
        {
          type = "delve",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Test (Package)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
        {
          type = "delve",
          name = "Attach to Process",
          request = "attach",
          mode = "local",
          processId = function()
            return require("dap.utils").pick_process()
          end,
        },
      }
    end,
  },
}
