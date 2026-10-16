-- ─── Treesitter — Syntax Highlighting ─────────────────────────
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
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
        "dockerfile",
        "sql",
        "printf",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        -- NOTE: `select` is disabled — mini.ai (extras.lua) provides the same
        -- treesitter queries with better coverage (af/if/ac/ic/aa/ia/...).
        select = {
          enable = false,
          lookahead = true,
          keymaps = {},
        },
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
      },
    },
  },
}
