return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          -- Avoid the sticky context from growing a lot.
          max_lines = 3,
          -- Match the context lines to the source code.
          multiline_threshold = 1,
          -- Disable it when the window is too small.
          min_window_height = 20,
        },
        keys = {
          {
            '[c',
            function()
              -- Jump to previous change when in diffview.
              if vim.wo.diff then
                return '[c'
              else
                vim.schedule(function()
                  require('treesitter-context').go_to_context()
                end)
                return '<Ignore>'
              end
            end,
            desc = 'Jump to upper context',
            expr = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      require('nvim-treesitter').install {
        -- "comment",
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
        "ninja",
        "php",
        "prisma",
        "python",
        "query",
        -- "rst",
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
        "vimdoc",
        "yaml",
      }
    end
  },

  -- html autotag for treesitter
  {
    'windwp/nvim-ts-autotag',
    -- lazy = false,
    event = "InsertEnter",
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
