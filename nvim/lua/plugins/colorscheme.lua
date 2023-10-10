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
      styles = {
        sidebars = "transparent"
      },
      on_highlights = function(hl, c)
        hl.Normal = { ctermbg = c.none }
        hl.StatusLine = { bg = c.bg }
        hl.NormalFloat = { bg = c.bg }
        hl.FloatBorder = { bg = c.none, fg = c.border_highlight }
        -- hl.FloatBorder = { bg = c.none, fg = c.bg_highlight }
        hl.CursorLineNr = { fg = c.magenta }
        hl.CursorLine = { bg = c.none, bold = false }
        hl.VertSplit = { fg = c.magenta }

        hl.TelescopeBorder = { bg = c.none, fg = c.border_highlight }
        hl.TelescopeNormal = { bg = c.none, fg = c.fg }
        hl.TelescopeSelection = { bg = c.none }

        -- FzfLua
        hl.FzfLuaBorder = { link = "FloatBorder" }

        hl.InclineNormal = { bg = c.bg }
        hl.InclineNormalNC = { fg = c.bg_highlight }

        hl.DiagnosticVirtualTextHint = { bg = c.none, fg = c.hint }
        hl.DiagnosticVirtualTextInfo = { bg = c.none, fg = c.info }
        hl.DiagnosticVirtualTextWarn = { bg = c.none, fg = c.warning }
        hl.DiagnosticVirtualTextError = { bg = c.none, fg = c.error }

        hl.NeoTreeNormal = { bg = c.bg }
        hl.NeoTreeNormalNC = { bg = c.bg }

        hl.NvimTreeNormal = { bg = c.bg }
        hl.NvimTreeNormalNC = { bg = c.bg }

        -- cmp
        hl.CmpItemAbbrDeprecated = { bg = 'NONE', strikethrough = true, fg = '#808080' }
        hl.CmpItemAbbrMatch = { bg = 'NONE', fg = '#569CD6' }
        hl.CmpItemAbbrMatchFuzzy = { link = 'CmpIntemAbbrMatch' }
        hl.CmpItemKindVariable = { bg = 'NONE', fg = '#9CDCFE' }
        hl.CmpItemKindInterface = { link = 'CmpItemKindVariable' }
        hl.CmpItemKindText = { link = 'CmpItemKindVariable' }
        hl.CmpItemKindFunction = { bg = 'NONE', fg = '#C586C0' }
        hl.CmpItemKindMethod = { link = 'CmpItemKindFunction' }
        hl.CmpItemKindKeyword = { bg = 'NONE', fg = '#D4D4D4' }
        hl.CmpItemKindProperty = { link = 'CmpItemKindKeyword' }
        hl.CmpItemKindUnit = { link = 'CmpItemKindKeyword' }
        hl.CmpItemKindCopilot = { fg = "#6CC644" }

        hl.Folded = {
          -- bg = '#15161e'
          bg = c.bg_dark
        }

        hl.LspInlayHint = {
          fg = c.comment,
          italic = true
        }

        -- Statusline
        hl.StatusLineModeNormal = { fg = c.orange }
        hl.StatusLineLSPNames = { bg = c.bg, fg = c.purple }
      end
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)

      vim.api.nvim_command("colorscheme tokyonight")
    end
  }
}
