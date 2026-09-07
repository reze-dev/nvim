-- ─── Testing — one workflow for Go, Rust, and C++ projects ────────
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-neotest/neotest-go", dependencies = { "nvim-neotest/neotest" } },
      { "rouge8/neotest-rust", dependencies = { "nvim-neotest/neotest" } },
      { "fredrikaverpil/neotest-golang", optional = true },
      { "alfaix/neotest-gtest", optional = true },
    },
    cmd = { "Neotest" },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run current file" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: run all (project)" },
      { "<leader>tw", function() require("neotest").watch.toggle() end, desc = "Test: toggle watch mode" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest (DAP)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: open output window" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: stop running test" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Test: jump next failed" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Test: jump previous failed" },
    },
    opts = function()
      local adapters = {}

      -- ─── Go Adapter (neotest-golang / neotest-go) ────────────────
      local ok_golang, neotest_golang = pcall(require, "neotest-golang")
      if ok_golang then
        table.insert(
          adapters,
          neotest_golang({
            runner = "go",
            go_test_args = { "-v", "-race", "-count=1" },
            dap_go_opts = {},
          })
        )
      else
        local ok_go, neotest_go = pcall(require, "neotest-go")
        if ok_go then
          table.insert(
            adapters,
            neotest_go({
              experimental = { test_table = true },
              args = { "-race", "-v", "-count=1" },
            })
          )
        end
      end

      -- ─── Rust Adapter (rustaceanvim.neotest / neotest-rust) ──────
      local ok_rustacean, rustacean_neotest = pcall(require, "rustaceanvim.neotest")
      if ok_rustacean then
        table.insert(adapters, rustacean_neotest)
      else
        local ok_rust, neotest_rust = pcall(require, "neotest-rust")
        if ok_rust then
          table.insert(
            adapters,
            neotest_rust({
              args = { "--no-capture" },
              dap_adapter = "codelldb",
            })
          )
        end
      end

      -- ─── C++ Adapter (neotest-gtest) ─────────────────────────────
      local ok_gtest, neotest_gtest = pcall(require, "neotest-gtest")
      if ok_gtest then
        table.insert(adapters, neotest_gtest({}))
      end

      return {
        adapters = adapters,
        status = { virtual_text = true, signs = true },
        output = { open_on_run = true },
        output_panel = { open_on_run = false },
        quickfix = { open = false },
      }
    end,
  },
}
