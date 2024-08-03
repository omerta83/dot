return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    -- event = { "BufReadPost", "BufNewFile" },
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,

        disable = { 'dart', 'python', 'css', 'rust' },
      },
      ensure_installed = {
        "comment",
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
        "query",
        "rst",
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
            ["<leader>a"] = { query = "@parameter.inner", desc = "[Text Objects] Swap with next argument/parameter" },
          },
          swap_previous = {
            ["<leader>A"] = { query = "@parameter.inner", desc = "[Text Objects] Swap with prev argument/parameter" }
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "[Text Objects] Next function start" },
            ["]]"] = { query = "@class.outer", desc = "[Text Objects] Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = { query = { "@loop.*", "@block.*", "@conditional.*" }, desc = "[Text Objects] Next loop/block/conditional" },
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            ["]a"] = { query = "@parameter.inner", desc = "[Text Objects] Next parameter" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "[Text Objects] Next function end" },
            ["]["] = { query = "@class.outer", desc = "[Text Objects] Next class end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "[Text Objects] Previous function start" },
            ["[["] = { query = "@class.outer", desc = "[Text Objects] Previous class end" },
            ["[a"] = "@parameter.inner",
            ["[o"] = { query = { "@loop.*", "@block.*", "@conditional.*" }, desc = "[Text Objects] Previous loop/block/conditional" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "[Text Objects] Previous function end" },
            ["[]"] = { query = "@class.outer", desc = "[Text Objects] Previous class end" },
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
    lazy = false,
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
