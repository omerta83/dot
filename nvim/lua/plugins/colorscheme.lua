return {
  {
    'catppuccin/nvim',
    name = "catppuccin",
    lazy = true,
    -- priority = 1000,
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
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        custom_highlights = function(colors)
          return {
            NormalFloat = { bg = colors.crust }, -- floating window background
            FloatBorder = { bg = colors.crust, fg = colors.surface0 },
            CursorLineNr = { fg = colors.mauve, style = { "bold" } },
            PmenuSel = { bg = colors.surface0, fg = colors.none },
            VertSplit = { fg = colors.surface0 },
            TelescopeSelection = { bg = colors.none, fg = colors.mauve },
            TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
            -- Neotree
            NeoTreeNormal = { bg = colors.base },
            NeoTreeNormalNC = { bg = colors.base },
            -- NeoTreeVertSplit = { bg = colors.mantle, fg = colors.mantle },
            -- NeoTreeWinSeparator = { bg = colors.mantle, fg = colors.mantle }
            InclineNormalNC = { guifg = colors.surface0 },
            -- Spaces and tabs
            NonText = { fg = colors.surface0 },
            -- Diagnostic
            DiagnosticVirtualTextHint = { bg = colors.none, fg = colors.surface0 },
            DiagnosticVirtualTextInfo = { bg = colors.none, fg = colors.surface0 },
            DiagnosticVirtualTextWarn = { bg = colors.none, fg = colors.surface0 },
            DiagnosticVirtualTextError = { bg = colors.none, fg = colors.surface0 },
          }
        end,
      }

      -- vim.api.nvim_command("colorscheme catppuccin")
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    -- priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = "hard",
        overrides = {
          SignColumn = { bg = "None" },
          GitSignsAdd = { bg = "None" },
          GitSignsChange = { bg = "None" },
          GitSignsDelete = { bg = "None" },
          GitSignsTopdelete = { bg = "None" },
          -- Diagnostic signs
          DiagnosticSignHint = { bg = "None" },
          DiagnosticSignInfo = { bg = "None" },
          DiagnosticSignWarn = { bg = "None" },
          DiagnosticSignError = { bg = "None" },
        }
      }

      vim.api.nvim_command("colorscheme gruvbox")

      local colors = require('util').theme_colors()
      local overrides = {
        -- floating window
        NormalFloat = { bg = colors.bg0 },
        FloatBorder = { bg = colors.bg0, fg = colors.bg1 },
        -- Diagnostic virtual text
        DiagnosticVirtualTextHint = { fg = colors.bg2 },
        DiagnosticVirtualTextInfo = { fg = colors.bg2 },
        DiagnosticVirtualTextWarn = { fg = colors.bg2 },
        DiagnosticVirtualTextError = { fg = colors.bg2 },
        -- Neotree
        NeoTreeNormal = { bg = colors.bg0 },
        NeoTreeNormalNC = { bg = colors.bg0 },
        -- Telescope
        TelescopePromptCounter = { fg = colors.orange, italic = true },
        -- incline
        InclineNormalNC = { fg = colors.bg1 },
        InclineNormal = { bg = colors.bg0 },
        -- Set statusline hl to remove extra colors
        StatusLine = { bg = colors.bg0 },
        CursorLineNr = { bg = colors.bg0, fg = colors.neutral_purple },
        -- terminal background
        Normal = { ctermbg = "None" },
      }

      for group, hl in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'night',
      on_highlights = function (hl, c)
        hl.Normal = { ctermbg = "None" }
        hl.InclineNormal = { bg = c.bg }
        hl.InclineNormalNC = { fg = c.bg_highlight }
        hl.DiagnosticVirtualTextHint = { bg = "None", fg = c.hint }
        hl.DiagnosticVirtualTextInfo = { bg = "None", fg = c.info }
        hl.DiagnosticVirtualTextWarn = { bg = "None", fg = c.warning }
        hl.DiagnosticVirtualTextError = { bg = "None", fg = c.error }
      end
    },
    config = function (_, opts)
      require('tokyonight').setup(opts)

      vim.api.nvim_command("colorscheme tokyonight")
    end
  }
}
