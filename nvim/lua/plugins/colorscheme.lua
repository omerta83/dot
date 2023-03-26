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
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'night',
      on_highlights = function (hl, c)
        hl.Normal = { ctermbg = c.none }
        hl.StatusLine = { bg = c.bg }

        hl.InclineNormal = { bg = c.bg }
        hl.InclineNormalNC = { fg = c.bg_highlight }

        hl.DiagnosticVirtualTextHint = { bg = c.none, fg = c.hint }
        hl.DiagnosticVirtualTextInfo = { bg = c.none, fg = c.info }
        hl.DiagnosticVirtualTextWarn = { bg = c.none, fg = c.warning }
        hl.DiagnosticVirtualTextError = { bg = c.none, fg = c.error }

        hl.NeoTreeNormal = { bg = c.bg }
        hl.NeoTreeNormalNC = { bg = c.bg }
      end
    },
    config = function (_, opts)
      require('tokyonight').setup(opts)

      vim.api.nvim_command("colorscheme tokyonight")
    end
  }
}
