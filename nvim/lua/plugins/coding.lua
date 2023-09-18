return {
  -- comment
  {
    "echasnovski/mini.comment",
    -- event = "VeryLazy",
    event = "BufReadPost",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
    },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          C = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if require("util.init").has("which-key.nvim") then
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
          C = "Comment",
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
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>rf",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "Refactor"
      },
    },
    opts = {},
  },
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

  -- multiple cursors
  -- {
  --   'mg979/vim-visual-multi',
  --   event = "BufReadPost",
  --   config = function()
  --     vim.g.VM_highlight_matches = 'underline'
  --     vim.g.VM_theme = 'codedark'
  --     vim.g.VM_leader = '<space>'
  --     vim.g.VM_maps = {
  --       ['Find Under'] = '<C-e>',
  --       ['Find Subword Under'] = '<C-e>',
  --       ['Select Cursor Down'] = '<space>j',
  --       ['Select Cursor Up'] = '<space>k',
  --     }
  --   end
  -- },

  -- Navigating
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   ---@type Flash.config
  --   opts = {
  --     modes = {
  --       char = {
  --         enabled = false,
  --         -- jump_labels = true,
  --       }
  --     },
  --   },
  --   keys = {
  --     {
  --       "s",
  --       mode = { "n", "o", "x" },
  --       function() require("flash").jump() end,
  --       desc = "Flash",
  --     },
  --     {
  --       "<leader>S",
  --       mode = { "n", "o", "x" },
  --       function() require("flash").treesitter() end,
  --       desc = "Flash Treesitter",
  --     },
  --     {
  --       "r",
  --       mode = "o",
  --       function() require("flash").remote() end,
  --       desc = "Remote Flash",
  --     },
  --     {
  --       "R",
  --       mode = { "o", "x" },
  --       function() require("flash").treesitter_search() end,
  --       desc = "Treesitter Search",
  --     },
  --   }
  -- },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        aliases = {
          ["<"] = "t",
        },
      })
    end
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>kv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
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
}
