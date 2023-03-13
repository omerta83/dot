return {

  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      -- local colors = require("tokyonight.colors").setup()
      local colors = require('catppuccin.palettes').get_palette()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormalNC = { guifg = colors.surface0 },
          },
        },
        hide = {
          only_win = true,
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local window = vim.api.nvim_win_get_number(props.win)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { window }, { " " }, { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      char = "▏",
      filetype_exclude = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble" },
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_end_of_line = true,
      show_current_context = true,
      context_char = "▏",
      space_char_blankline = " ",
      char_priority = 50, -- fix for nvim-ufo integration
    }
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
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

  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
      require("util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = "  ",
        highlight = true,
        depth_limit = 5,
        icons = require('config.icons').kinds
      }
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
