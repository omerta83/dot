return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false,
          dismiss = "<C-c>",
        }
      },
      panel = {
        enabled = false,
      }
    }
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    event = { "BufReadPost", "BufNewFile" },
    -- event = "VeryLazy",
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

  {
    "echasnovski/mini.ai",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        silent = true,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          -- t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if require("util").has("which-key.nvim") then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register({
          mode = { "o", "x" },
          i = i,
          a = a,
        })
      end
    end,
  },

  -- Generate docs
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  -- refactoring
  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   keys = {
  --     {
  --       "<leader>rf",
  --       function()
  --         require("refactoring").select_refactor()
  --       end,
  --       mode = "v",
  --       noremap = true,
  --       silent = true,
  --       expr = false,
  --       desc = "Refactor"
  --     },
  --   },
  --   opts = {},
  -- },

  -- {
  --   "simrat39/symbols-outline.nvim",
  --   keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  --   opts = function()
  --     local icons = require('config.icons').kinds
  --     return {
  --       auto_close = true,
  --       preview_bg_highlight = "None",
  --       symbols = {
  --         File = { icon = icons.File, hl = "@text.uri" },
  --         Module = { icon = icons.Module, hl = "@namespace" },
  --         Namespace = { icon = icons.Namespace, hl = "@namespace" },
  --         Package = { icon = icons.Package, hl = "@namespace" },
  --         Class = { icon = icons.Class, hl = "@type" },
  --         Method = { icon = icons.Method, hl = "@method" },
  --         Property = { icon = icons.Property, hl = "@method" },
  --         Field = { icon = icons.Field, hl = "@field" },
  --         Constructor = { icon = icons.Constructor, hl = "@constructor" },
  --         Enum = { icon = icons.Enum, hl = "@type" },
  --         Interface = { icon = icons.Interface, hl = "@type" },
  --         Function = { icon = icons.Function, hl = "@function" },
  --         Variable = { icon = icons.Variable, hl = "@constant" },
  --         Constant = { icon = icons.Constant, hl = "@constant" },
  --         String = { icon = icons.String, hl = "@string" },
  --         Number = { icon = icons.Number, hl = "@number" },
  --         Boolean = { icon = icons.Boolean, hl = "@boolean" },
  --         Array = { icon = icons.Array, hl = "@constant" },
  --         Object = { icon = icons.Object, hl = "@type" },
  --         Key = { icon = icons.Key, hl = "@type" },
  --         Null = { icon = icons.Null, hl = "@type" },
  --         EnumMember = { icon = icons.EnumMember, hl = "@field" },
  --         Struct = { icon = icons.Struct, hl = "@type" },
  --         Event = { icon = icons.Event, hl = "@type" },
  --         Operator = { icon = icons.Operator, hl = "@operator" },
  --         TypeParameter = { icon = icons.TypeParameter, hl = "@parameter" },
  --         Component = { icon = icons.Constructor, hl = "@function" },
  --         Fragment = { icon = icons.Fragment, hl = "@constant" },
  --       }
  --     }
  --   end
  --   -- config = true,
  -- },

  -- Better rename symbols
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      -- { "<leader>rn", ":IncRename ", desc = "Rename" }
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand('<cword>')
        end,
        expr = true,
        desc = "Rename identifier under cursor"
      }
    },
    -- config = true
    config = function()
      require("inc_rename").setup {
        input_buffer_type = "dressing",
      }
    end,
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.hexcolor.new {
            case = "lower",
          }
        },
      })
    end,
  },

  -- Navigating
  {
    "folke/flash.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      labels = "0123456789", -- prevent messing with inserting characters
      search = {
        multi_window = false,
      },
      modes = {
        char = {
          autohide = true,
          jump_labels = true,
          label = { exclude = "hjkliardcx" },
          multi_line = false,
        }
      },
    },
    keys = {
      {
        "<leader>s",
        mode = { "n", "o", "x" },
        function() require("flash").jump() end,
        desc = "Flash",
      },
      {
        "<leader>S",
        mode = { "n", "o", "x" },
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

  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
    config = function(_, opts)
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.setup(opts)
      npairs.add_rules({
        Rule("|", "|", { "rust" })
      })
    end
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>tv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded",          -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
      focus_preview = false,       -- Sets the preview as the current window
      copy_register = "",          -- The register to copy values to,
      -- keymaps = {
      --   copy = "<C-y>"               -- Normal mode keymap to copy the CSS values between {}
      -- }
    }
  },

  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = { timer = 250 },
      ring = { history_length = 20 },
    },
    keys = {
      -- stylua: ignore
      { "<leader>p", "<Cmd>YankyRingHistory<CR>", desc = "Open Yank History" },
      {
        "y",
        "<Plug>(YankyYank)",
        desc = "Yank text",
        mode = { "n", "x" },
      },
      {
        "p",
        "<Plug>(YankyPutAfter)",
        desc =
        "Put yanked text after cursor",
        mode = { "n", "x" }
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        desc =
        "Put yanked text before cursor",
        mode = { "n", "x" }
      },
      -- {
      --   "gp",
      --   "<Plug>(YankyGPutAfter)",
      --   desc =
      --   "Put yanked text after selection",
      --   mode = { "n", "x" }
      -- },
      -- {
      --   "gP",
      --   "<Plug>(YankyGPutBefore)",
      --   desc =
      --   "Put yanked text before selection",
      --   mode = { "n", "x" }
      -- },
      { "[y", "<Plug>(YankyCycleForward)",              desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)",             desc = "Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)",            desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)",           desc = "Put before applying a filter" },
    },
  },

  -- {
  --   'echasnovski/mini.move',
  --   event = 'VeryLazy',
  --   config = true,
  -- }
}
