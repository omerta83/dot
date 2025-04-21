return {
  -- comment
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    opts = {
      enable_autocmd = false,
    }
  },

  -- {
  --   'numToStr/Comment.nvim',
  --   -- event = { "BufReadPost", "BufNewFile" },
  --   event = "VeryLazy",
  --   dependencies = 'nvim-ts-context-commentstring',
  --   config = function()
  --     require('Comment').setup({
  --       pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  --     })
  --   end
  -- },

  {
    'echasnovski/mini.comment',
    version = false,
    event = "VeryLazy",
    dependencies = 'nvim-ts-context-commentstring',
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
        end,
      }
    }
  },

  --- Generate docs
  {
    "danymat/neogen",
    cmd = "Neogen",
    -- dependencies = 'echasnovski/mini.snippets',
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Generate [c]omment",
      },
    },
    opts = { snippet_engine = "nvim" },
  },

  --- refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>cxr",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Refacto[r] selector"
      },
      {
        "<leader>cxx",
        function() require('refactoring').refactor('Extract Function') end,
        mode = "x",
        desc = "E[x]tract function"
      },
      {
        "<leader>cxf",
        function() require('refactoring').refactor('Extract Function To File') end,
        mode = "x",
        desc = "Extract function to [f]ile",
      },
      {
        "<leader>cxv",
        function() require('refactoring').refactor('Extract Variable') end,
        mode = "x",
        desc = "Extract [v]ariable",
      },
      {
        "<leader>cxi",
        function() require('refactoring').refactor('Inline Variable') end,
        mode = { "n", "x" },
        desc = "Extract [i]nline variable",
      },
      {
        "<leader>cxb",
        function() require('refactoring').refactor('Extract Block') end,
        mode = "n",
        desc = "Extract [b]lock",
      },
      {
        "<leader>cxB",
        function() require('refactoring').refactor('Extract Block To File') end,
        mode = "n",
        desc = "Extract [B]lock to file",
      }
    },
    opts = {},
  },

  -- Better rename symbols
  -- {
  --   "smjonas/inc-rename.nvim",
  --   cmd = "IncRename",
  --   keys = {
  --     -- { "<leader>rn", ":IncRename ", desc = "Rename" }
  --     {
  --       "<leader>rn",
  --       function()
  --         return ":IncRename " .. vim.fn.expand('<cword>')
  --       end,
  --       expr = true,
  --       desc = "Rename identifier under cursor"
  --     }
  --   },
  --   -- config = true
  --   config = function()
  --     require("inc_rename").setup {
  --       input_buffer_type = "dressing",
  --     }
  --   end,
  -- },

  -- better increase/descrease
  {
    "nat-418/boole.nvim",
    cmd = "Boole",
    keys = { "<C-a>", "<C-x>" },
    opts = {
      mappings = {
        increment = '<C-a>',
        decrement = '<C-x>'
      },
    }
  },

  -- -- Navigating
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- labels = "0123456789", -- prevent messing with inserting characters for / and ?
      search = {
        multi_window = false,
      },
      jump = {
        -- automatically jump when there is only one match
        autojump = true,
      },
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          enabled = true,
        },
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
          autohide = true,
          jump_labels = true,
          multi_line = false,
          jump = {
            -- hide labels after jump if only one match
            autojump = true,
          },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function() require("flash").jump() end,
        desc = "Flash",
      },
      -- use a jump label, or use ; and , to increase/decrease the selection
      -- S can be chained to increase the selection
      {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search",
      },
    }
  },

  -- surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({
        aliases = {
          ["<"] = "t",
        },
      })
    end
  },
}
