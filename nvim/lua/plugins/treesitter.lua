return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,

        -- NOTE: enabling indentation significantly slows down editing in Dart files
        disable = { 'dart' },
      },
      ensure_installed = {
        "css",
        "dart",
        "diff",
        "gitignore",
        "go",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "prisma",
        "query",
        "rust",
        "scss",
        "solidity",
        "sql",
        "svelte",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vue",
        "yaml",
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      matchup = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<TAB>",
          node_decremental = "<bs>"
        }
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- html autotag for treesitter
  {
    'windwp/nvim-ts-autotag',
    event = "BufReadPost",
    config = function()
      require('nvim-ts-autotag').setup({
        enable_close_on_slash = false,
        enable_rename = false,
        filetypes = {
          "html",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "xml",
        },
      })
    end
  }
}
