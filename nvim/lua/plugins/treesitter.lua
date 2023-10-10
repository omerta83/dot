return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
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
          node_incremental = "v",
          node_decremental = "V"
        }
      },
      textobjects = {
        select = {
          enable = false, -- use mini.ai for selection
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
            ["]o"] = { query = { "@loop.*", "@block.*", "@conditional.*" } },
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
            ["[a"] = "@parameter.inner",
            ["[o"] = { query = { "@loop.*", "@block.*", "@conditional.*" } },
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
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
