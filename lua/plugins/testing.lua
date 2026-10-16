-- ─── Testing — one workflow for Go, Rust, and C++ projects ────────
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      { "mrcjkb/rustaceanvim", version = "^5" },
      { "fredrikaverpil/neotest-golang" },
      { "alfaix/neotest-gtest" },
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
      -- Adapters: rustaceanvim (Rust), neotest-golang (Go), neotest-gtest (C++)
      local adapters = {}

      local ok_rust, rustacean_neotest = pcall(require, "rustaceanvim.neotest")
      if ok_rust then
        table.insert(adapters, rustacean_neotest)
      end

      local ok_golang, neotest_golang = pcall(require, "neotest-golang")
      if ok_golang then
        table.insert(
          adapters,
          neotest_golang({
            runner = "go",
            go_test_args = { "-v", "-race", "-count=1" },
          })
        )
      end

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
