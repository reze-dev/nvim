return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerClose",
      "OverseerOpen",
      "OverseerRun",
      "OverseerShell",
      "OverseerTaskAction",
      "OverseerToggle",
    },
    keys = {
      {
        "<leader>or",
        "<cmd>OverseerRun<CR>",
        desc = "Overseer run task",
      },
      {
        "<leader>ot",
        "<cmd>OverseerToggle<CR>",
        desc = "Overseer toggle tasks",
      },
      {
        "<leader>oq",
        "<cmd>OverseerTaskAction<CR>",
        desc = "Overseer task action",
      },
      {
        "<leader>oc",
        "<cmd>OverseerShell<CR>",
        desc = "Overseer shell command",
      },
    },
    opts = {
      component_aliases = {
        default = {
          "on_exit_set_status",
          "on_complete_notify",
          { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" }, timeout = 900 },
        },
        default_vscode = {
          "default",
          "on_result_diagnostics",
          { "on_result_diagnostics_trouble", open = false },
        },
      },
      task_list = {
        direction = "bottom",
        min_height = 12,
        max_height = 18,
        default_detail = 1,
      },
      form = {
        border = "rounded",
      },
      confirm = {
        border = "rounded",
      },
      task_win = {
        border = "rounded",
      },
    },
  },
}
