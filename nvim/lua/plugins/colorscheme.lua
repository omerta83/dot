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
    lazy = false,
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = "hard",
        overrides = {
          SignColumn = { bg = "None" },
          GitSignsAdd = { bg = "None" },
          GitSignsChange = { bg = "None" },
          GitSignsDelete = { bg = "None" },
          GitSignsTopdelete = { bg = "None" },
          -- Diagnostic
          DiagnosticSignHint = { bg = "None" },
          DiagnosticSignInfo = { bg = "None" },
          DiagnosticSignWarn = { bg = "None" },
          DiagnosticSignError = { bg = "None" },
        }
      }

      vim.api.nvim_command("colorscheme gruvbox")

      local colors = require('util').theme_colors()
      local overrides = {
        -- Diagnostic
        DiagnosticVirtualTextHint = { fg = colors.bg1 },
        DiagnosticVirtualTextInfo = { fg = colors.bg1 },
        DiagnosticVirtualTextWarn = { fg = colors.bg1 },
        DiagnosticVirtualTextError = { fg = colors.bg1 },
        -- Neotree
        NeoTreeNormal = { bg = colors.bg0 },
        NeoTreeNormalNC = { bg = colors.bg0 },
        -- incline
        InclineNormalNC = { fg = colors.bg1 },
        InclineNormal = { bg = colors.bg0 },

        -- Set statusline hl to remove extra colors
        StatusLine = { bg = colors.bg0 },

        CursorLineNr = { bg = colors.bg0, fg = colors.neutral_purple },
      }

      for hl, v in pairs(overrides) do
        vim.api.nvim_set_hl(0, hl, v)
      end

      -- fix for toggleterm background, cannot use vim.api.nvim_set_hl
      vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]
    end
  }
}
