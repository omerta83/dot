return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    -- event = { "BufReadPost", "BufNewFile" },
    main = 'ibl',
    opts = {
      indent = {
        char = "▏",
        priority = 50,
      },
      scope = {
        enabled = true,
        char = "▏",
        show_start = false,
        show_end = false
      },
      whitespace = {
        remove_blankline_trail = true
      },
      exclude = {
        filetypes = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" }
      }
      -- filetype_exclude = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" },
      -- filetype = require('nvim-treesitter.configs').get_ensure_installed_parsers(), -- keep in sync with nvim-treesitter
      -- use_treesitter = true,
      -- show_trailing_blankline_indent = false,
      -- show_first_indent_level = false,
      -- show_end_of_line = true,
      -- show_current_context = true,
      -- context_char = "▏",
      -- space_char_blankline = " ",
      -- char_priority = 50, -- fix for nvim-ufo integration
    },
    configs = function(_, opts)
      require('ibl').setup(opts)
      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
    end
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        win_options = {
          winhighlight = 'FloatBorder:LspFloatWinBorder',
          winblend = 5,
        },
      },
      select = {
        trim_prompt = false,
        get_config = function()
          return {
            backend = 'fzf_lua',
            fzf_lua = {
              winopts = {
                height = 0.6,
                width = 0.6,
                row = 0.4,
              }
            },
          }
        end,
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    "f-person/auto-dark-mode.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
