return {
  --- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-CR>',
          accept_word = '<M-w>',
          accept_line = '<M-e>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-e>',
        }
      },
      panel = {
        enabled = false,
      }
    },
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    -- event = { "BufReadPost", "BufNewFile" },
    event = "VeryLazy",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      init = function ()
        vim.g.skip_ts_context_commentstring_module = true
      end,
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
  -- {
  --   'folke/ts-comments.nvim',
  --   opts = {},
  --   event = 'VeryLazy',
  --   enabled = vim.fn.has('nvim-0.10.0') == 1,
  -- },

  {
    'echasnovski/mini.ai',
    -- event = "VeryLazy",
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter-textobjects' },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        -- Whether to disable showing non-error feedback
        silent = true,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
          C = require('vim._comment').textobject,                                       -- Comment
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
          d = { "%f[%d]%d+" },                                                          -- digits
          e = {                                                                         -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          i = require('util.mini').ai_indent,                        -- indent
          g = require('util.mini').ai_buffer,                        -- buffer
          u = ai.gen_spec.function_call(),                           -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if require("util").has("which-key.nvim") then
        vim.schedule(function()
          require('util.mini').ai_whichkey(opts)
        end)
      end
    end,
  },

  --- Generate docs
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = 'echasnovski/mini.snippets',
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Generate [c]omment",
      },
    },
    opts = { snippet_engine = "mini" },
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
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({
        aliases = {
          ["<"] = "t",
        },
      })
    end
  },
}
