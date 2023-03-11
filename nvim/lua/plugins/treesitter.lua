return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    version = false,
    -- build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- lazy = false,
    dependencies = {
      -- "andymass/vim-matchup",
      -- "windwp/nvim-ts-autotag",
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      -- "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
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
      -- query_linter = {
      --   enable = true,
      --   use_virtual_text = true,
      --   lint_events = { "BufWrite", "CursorHold" },
      -- },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      -- autotag = {
      --   enable = true,
      -- },
      matchup = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
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
    config = function ()
      require('nvim-ts-autotag').setup()
    end
  }
}
