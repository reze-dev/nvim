-- ─── Treesitter — Syntax Highlighting (nvim-treesitter `main` API) ──
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", "TSUninstall" },
    dependencies = {
      -- Kept for the new main-compatible move/swap/select modules.
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        -- Systems
        "c",
        "cpp",
        "rust",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "gotmpl",
        "llvm",
        "make",
        "cmake",
        "zig",
        "python",
        "lua",
        "luadoc",
        "luap",
        -- Web
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "scss",
        -- Data
        "json",
        "json5",
        "jsonc",
        "yaml",
        "toml",
        "xml",
        -- Config
        "nix",
        "fish",
        "bash",
        "dockerfile",
        "hcl",
        "terraform",
        -- Docs
        "markdown",
        "markdown_inline",
        "vimdoc",
        "vim",
        "regex",
        -- Other
        "query",
        "diff",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "sql",
        "printf",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      -- install_dir keeps parsers out of the plugin dir (survives updates)
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/treesitter",
      })
      ts.install(opts.ensure_installed or {})

      -- Start highlighting + indent per buffer (main-branch API).
      -- Big files are guarded by the BigFile autocmd (sets b.bigfile).
      local group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          if vim.b[args.buf].bigfile then
            return
          end
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- textobjects (move / swap) on the new API. `select` stays off —
      -- mini.ai (extras.lua) provides the same queries with better coverage.
      local ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
      if ok and ts_textobjects.setup then
        ts_textobjects.setup({
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[c"] = { query = "@class.outer", desc = "Previous class start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>cx"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
            },
            swap_previous = {
              ["<leader>cX"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
            },
          },
        })
        -- `]c` is also Vim's diff jump; let diff mode win.
        vim.api.nvim_create_autocmd("FileType", {
          group = group,
          callback = function(args)
            if vim.wo.diff then
              pcall(vim.keymap.del, "n", "]c", { buffer = args.buf })
              pcall(vim.keymap.del, "n", "[c", { buffer = args.buf })
            end
          end,
        })
      end

      -- Incremental selection: <C-space> init/increment, <BS> decrement.
      -- Implemented natively (main branch removed the legacy module).
      local function node_incremental()
        local ok_ts, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
        if ok_ts and ts_utils and ts_utils.update_selection then
          ts_utils.update_selection(1)
          return
        end
        -- Fallback: expand to treesitter node via vim.treesitter
        local node = vim.treesitter.get_node()
        if node then
          local srow, scol, erow, ecol = node:range()
          vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
          vim.cmd("normal! v")
          vim.api.nvim_win_set_cursor(0, { erow + 1, ecol - 1 })
        end
      end
      vim.keymap.set({ "n", "x" }, "<C-space>", node_incremental, { desc = "Treesitter: incremental selection" })
    end,
  },
}
