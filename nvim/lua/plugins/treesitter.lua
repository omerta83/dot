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
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<bs>"
        }
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select a function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            ["ac"] = { query = "@class.outer", desc = "Select a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["aa"] = { query = "@parameter.outer", desc = "Select a parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
          },
          include_surrounding_whitespace = false,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next argument/parameter" },
          },
          swap_previous = {
            ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with prev argument/parameter" }
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[a"] = "@parameter.inner"
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            ["]c"] = "@conditional.outer",
          },
          goto_previous = {
            ["[c"] = "@conditional.outer",
          }
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
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
