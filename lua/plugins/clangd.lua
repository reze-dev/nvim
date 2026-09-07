-- ─── Clangd Extensions — C/C++ Development Tools ─────────────────
return {
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    opts = {
      inlay_hints = {
        inline = false,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
      },
      ast = {
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
      type_hierarchy = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("clangd_extensions").setup(opts)

      -- Clangd-specific buffer keymaps
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ClangdKeymaps", { clear = true }),
        pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Clangd: " .. desc })
          end

          map("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch source/header")
          map("<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", "Type hierarchy")
          map("<leader>cm", "<cmd>ClangdMemoryUsage<cr>", "Memory usage")
          map("<leader>cs", "<cmd>ClangdSymbolInfo<cr>", "Symbol info")
          map("<leader>cA", "<cmd>ClangdAST<cr>", "View AST")
        end,
      })
    end,
  },
}
