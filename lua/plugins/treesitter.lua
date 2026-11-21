-- ─── Treesitter — Syntax Highlighting (nvim-treesitter `main` API) ──
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSUninstall" },
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
      vim.treesitter.language.register("json5", "jsonc")
      -- install_dir keeps parsers out of the plugin dir (survives updates)
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/treesitter",
      })
      ts.install(opts.ensure_installed or {})

      -- Start highlighting per buffer.
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

      local move = require("nvim-treesitter-textobjects.move")
      local function motion(key, jump, query, desc)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          if vim.wo.diff and (key == "]c" or key == "[c") then
            vim.cmd.normal({ args = { vim.v.count1 .. key }, bang = true })
            return
          end
          jump(query, "textobjects")
        end, { desc = desc })
      end

      for key, object in pairs({ f = "function", c = "class", a = "parameter" }) do
        local query = "@" .. object .. ".outer"
        motion("]" .. key, move.goto_next_start, query, "Next " .. object)
        motion("[" .. key, move.goto_previous_start, query, "Previous " .. object)
      end
      for key, object in pairs({ F = "function", C = "class" }) do
        local query = "@" .. object .. ".outer"
        motion("]" .. key, move.goto_next_end, query, "End of next " .. object)
        motion("[" .. key, move.goto_previous_end, query, "End of previous " .. object)
      end

      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>cx", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>cX", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap with previous parameter" })

      vim.keymap.set({ "n", "x" }, "<C-space>", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Expand syntax selection" })
      vim.keymap.set("x", "<BS>", function()
        vim.treesitter.select("child", vim.v.count1)
      end, { desc = "Shrink syntax selection" })
    end,
  },
}
