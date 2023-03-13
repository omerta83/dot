return {
  'catppuccin/nvim',
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local mantle = "#11111f"
    require('catppuccin').setup {
      term_colors = true,
      flavour = 'mocha',
      transparent_background = false,
      no_italic = false,
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = mantle,
          crust = "#000000",
        },
      },
      integrations = {
        -- treesitter_context = true,
        illuminate = true,
        lsp_trouble = true,
        -- lsp_saga = true,
        neotree = true,
        -- nvimtree = true,
        symbols_outline = true,
        navic = {
          enabled = true,
          custom_bg = mantle
        },
        dap = {
          enabled = true,
          enable_ui = true,
        },
      },
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = { "bold" },
        booleans = {},
        properties = {},
        types = { "bold" },
        operators = {},
      },
      custom_highlights = function(colors)
        return {
          NormalFloat = { bg = colors.crust }, -- floating window background
          FloatBorder = { bg = colors.crust, fg = colors.surface0 },
          CursorLineNr = { fg = colors.mauve, style = { "bold" } },
          PmenuSel = { bg = colors.surface0, fg = "" },
          VertSplit = { fg = colors.surface0 },
          TelescopeSelection = { bg = '', fg = colors.mauve },
          TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
          -- Neotree
          NeoTreeNormal = { bg = colors.base },
          NeoTreeNormalNC = { bg = colors.base },
          -- NeoTreeVertSplit = { bg = colors.mantle, fg = colors.mantle },
          -- NeoTreeWinSeparator = { bg = colors.mantle, fg = colors.mantle }
          -- Fzf
          -- FzfLuaTitle = { fg = colors.mauve }
          IlluminatedWordText = { bg = colors.surface2 },
          IlluminatedWordRead = { bg = colors.surface2 },
          IlluminatedWordWrite = { bg = colors.surface2 },
        }
      end,
    }

    vim.api.nvim_command("colorscheme catppuccin")
  end
}
