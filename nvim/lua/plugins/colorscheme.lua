return {
  -- {
  --   'catppuccin/nvim',
  --   name = "catppuccin",
  --   lazy = true,
  --   -- priority = 1000,
  --   config = function()
  --     local mantle = "#11111f"
  --     require('catppuccin').setup {
  --       term_colors = true,
  --       flavour = 'mocha',
  --       transparent_background = false,
  --       no_italic = false,
  --       color_overrides = {
  --         mocha = {
  --           base = "#000000",
  --           mantle = mantle,
  --           crust = "#000000",
  --         },
  --       },
  --       integrations = {
  --         -- treesitter_context = true,
  --         illuminate = true,
  --         lsp_trouble = true,
  --         -- lsp_saga = true,
  --         neotree = true,
  --         -- nvimtree = true,
  --         symbols_outline = true,
  --         navic = {
  --           enabled = true,
  --           custom_bg = mantle
  --         },
  --         dap = {
  --           enabled = true,
  --           enable_ui = true,
  --         },
  --       },
  --       styles = {
  --         comments = {},
  --         conditionals = {},
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       custom_highlights = function(colors)
  --         return {
  --           NormalFloat = { bg = colors.crust }, -- floating window background
  --           FloatBorder = { bg = colors.crust, fg = colors.surface0 },
  --           CursorLineNr = { fg = colors.mauve, style = { "bold" } },
  --           PmenuSel = { bg = colors.surface0, fg = colors.none },
  --           VertSplit = { fg = colors.surface0 },
  --           TelescopeSelection = { bg = colors.none, fg = colors.mauve },
  --           TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
  --           -- Neotree
  --           NeoTreeNormal = { bg = colors.base },
  --           NeoTreeNormalNC = { bg = colors.base },
  --           -- NeoTreeVertSplit = { bg = colors.mantle, fg = colors.mantle },
  --           -- NeoTreeWinSeparator = { bg = colors.mantle, fg = colors.mantle }
  --           InclineNormalNC = { guifg = colors.surface0 },
  --           -- Spaces and tabs
  --           NonText = { fg = colors.surface0 },
  --           -- Diagnostic
  --           DiagnosticVirtualTextHint = { bg = colors.none, fg = colors.surface0 },
  --           DiagnosticVirtualTextInfo = { bg = colors.none, fg = colors.surface0 },
  --           DiagnosticVirtualTextWarn = { bg = colors.none, fg = colors.surface0 },
  --           DiagnosticVirtualTextError = { bg = colors.none, fg = colors.surface0 },
  --         }
  --       end,
  --     }
  --
  --     -- vim.api.nvim_command("colorscheme catppuccin")
  --   end
  -- },

  -- {
  --   "EdenEast/nightfox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     groups = {
  --       all = {
  --         StatusLine                = { bg = "bg1" },
  --         NormalFloat               = { bg = "bg1" },
  --         FloatBorder               = { bg = "bg1", fg = "bg4" },
  --
  --         -- CursorLineNr = { fg = "magenta" },
  --         CursorLine                = { bg = "bg1", fg = "NONE" },
  --
  --         Pmenu                     = { bg = "bg2", fg = "NONE" },
  --
  --         -- FZF
  --         FzfLuaBorder              = { link = "FloatBorder" },
  --         FzfLuaBackdrop            = { bg = "bg1" },
  --
  --         -- Blink
  --         BlinkCmpMenuBorder        = { link = "FloatBorder" },
  --         BlinkCmpMenuSelection     = { link = "Pmenu" },
  --         -- BlinkCmpDoc               = { link = "CmpDocumentation" },
  --         -- BlinkCmpDocBorder         = { link = "CmpDocumentationBorder" },
  --         BlinkCmpDocBorder         = { link = "FloatBorder" },
  --         BlinkCmpLabel             = { link = "CmpItemAbbr" },
  --         BlinkCmpLabelDeprecated   = { link = "CmpItemAbbrDeprecated" },
  --         BlinkCmpLabelMatch        = { link = "CmpItemAbbrMatch" },
  --         BlinkCmpMenu              = { link = "CmpItemMenu" },
  --         -- BlinkCmpKind              = { link = "CmpItemKindDefault" },
  --         BlinkCmpKind              = { link = "CmpItemKindValue" },
  --         BlinkCmpKindKeyword       = { link = "CmpItemKindKeyword" },
  --         BlinkCmpKindVariable      = { link = "CmpItemKindVariable" },
  --         BlinkCmpKindConstant      = { link = "CmpItemKindConstant" },
  --         BlinkCmpKindReference     = { link = "CmpItemKindReference" },
  --         BlinkCmpKindValue         = { link = "CmpItemKindValue" },
  --         BlinkCmpKindFunction      = { link = "CmpItemKindFunction" },
  --         BlinkCmpKindMethod        = { link = "CmpItemKindMethod" },
  --         BlinkCmpKindConstructor   = { link = "CmpItemKindConstructor" },
  --         BlinkCmpKindInterface     = { link = "CmpItemKindInterface" },
  --         BlinkCmpKindEvent         = { link = "CmpItemKindEvent" },
  --         BlinkCmpKindEnum          = { link = "CmpItemKindEnum" },
  --         BlinkCmpKindUnit          = { link = "CmpItemKindUnit" },
  --         BlinkCmpKindClass         = { link = "CmpItemKindClass" },
  --         BlinkCmpKindStruct        = { link = "CmpItemKindStruct" },
  --         BlinkCmpKindModule        = { link = "CmpItemKindModule" },
  --         BlinkCmpKindProperty      = { link = "CmpItemKindProperty" },
  --         BlinkCmpKindField         = { link = "CmpItemKindField" },
  --         BlinkCmpKindTypeParameter = { link = "CmpItemKindTypeParameter" },
  --         BlinkCmpKindEnumMember    = { link = "CmpItemKindEnumMember" },
  --         BlinkCmpKindOperator      = { link = "CmpItemKindOperator" },
  --         BlinkCmpKindSnippet       = { link = "CmpItemKindSnippet" },
  --       }
  --     }
  --
  --   },
  --   config = function(_, opts)
  --     require('nightfox').setup(opts)
  --
  --     vim.api.nvim_command("colorscheme carbonfox")
  --   end
  -- },

  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      keywordStyle = { italic = false },
      overrides = function(colors)
        local theme = colors.theme
        local palette = colors.palette
        return {
          -- Shortcut to transparent background
          NoneBg = { bg = "none" },
          CursorLine = { link = "NoneBg" },
          StatusLine = { link = "NoneBg" },
          NormalFloat = { link = "NoneBg" },
          FloatBorder = { link = "NoneBg" },
          FloatTitle = { link = "NoneBg" },

          CursorLineNr = { fg = palette.dragonGray2 },

          FzfLuaBackdrop = { bg = theme.ui.bg },
          FzfLuaNormal = { bg = theme.ui.bg },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg, fg = theme.ui.fg_dim },

          -- Autocompletion popup
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg }, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          LspReferenceWrite = { underline = false },

          -- Blink
          BlinkCmpMenuBorder        = { link = "FloatBorder" },
          -- BlinkCmpMenuSelection     = { fg = theme.syn.comment, bg = 'none' },
          BlinkCmpDocBorder         = { link = "FloatBorder" },

          -- LspInlayHint = { bg = theme.ui.nontext, fg = theme.ui.bg_m3 },
          LspInlayHint = { fg = theme.ui.nontext },
          ["@lsp.typemod.function.readonly"] = { bold = false },
          -- Make this treesitter hl the same as lsp's semantic highlighting
          ["@variable"] = { link = "Constant" },
          ["@type"] = { link = "Constant" },
        }
      end,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            }
          }
        }
      },
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      -- Drop the priority of semantic tokens below treesitter (100)
      -- vim.highlight.priorities.semantic_tokens = 75
      vim.api.nvim_command("colorscheme kanagawa-dragon")
    end
  },

  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = true,
  --   priority = 1000,
  --   opts = {
  --     style = 'night',
  --     styles = {
  --       sidebars = "transparent"
  --     },
  --     on_highlights = function(hl, c)
  --       hl.Normal = { ctermbg = c.none }
  --       hl.StatusLine = { bg = c.bg }
  --       hl.NormalFloat = { bg = c.bg }
  --       hl.FloatBorder = { bg = c.none, fg = c.border_highlight }
  --       -- hl.FloatBorder = { bg = c.none, fg = c.bg_highlight }
  --       hl.CursorLineNr = { fg = c.magenta }
  --       hl.CursorLine = { bg = c.none, bold = false }
  --       hl.VertSplit = { fg = c.magenta }
  --
  --       hl.TelescopeBorder = { bg = c.none, fg = c.border_highlight }
  --       hl.TelescopeNormal = { bg = c.none, fg = c.fg }
  --       hl.TelescopeSelection = { bg = c.none }
  --
  --       -- FzfLua
  --       hl.FzfLuaBorder = { link = "FloatBorder" }
  --
  --       hl.InclineNormal = { bg = c.bg }
  --       hl.InclineNormalNC = { fg = c.bg_highlight }
  --
  --       hl.DiagnosticVirtualTextHint = { bg = c.none, fg = c.hint }
  --       hl.DiagnosticVirtualTextInfo = { bg = c.none, fg = c.info }
  --       hl.DiagnosticVirtualTextWarn = { bg = c.none, fg = c.warning }
  --       hl.DiagnosticVirtualTextError = { bg = c.none, fg = c.error }
  --
  --       hl.NeoTreeNormal = { bg = c.bg }
  --       hl.NeoTreeNormalNC = { bg = c.bg }
  --
  --       hl.NvimTreeNormal = { bg = c.bg }
  --       hl.NvimTreeNormalNC = { bg = c.bg }
  --
  --       -- cmp
  --       hl.CmpItemAbbrDeprecated = { bg = 'NONE', strikethrough = true, fg = '#808080' }
  --       hl.CmpItemAbbrMatch = { bg = 'NONE', fg = '#569CD6' }
  --       hl.CmpItemAbbrMatchFuzzy = { link = 'CmpIntemAbbrMatch' }
  --       hl.CmpItemKindVariable = { bg = 'NONE', fg = '#9CDCFE' }
  --       hl.CmpItemKindInterface = { link = 'CmpItemKindVariable' }
  --       hl.CmpItemKindText = { link = 'CmpItemKindVariable' }
  --       hl.CmpItemKindFunction = { bg = 'NONE', fg = '#C586C0' }
  --       hl.CmpItemKindMethod = { link = 'CmpItemKindFunction' }
  --       hl.CmpItemKindKeyword = { bg = 'NONE', fg = '#D4D4D4' }
  --       hl.CmpItemKindProperty = { link = 'CmpItemKindKeyword' }
  --       hl.CmpItemKindUnit = { link = 'CmpItemKindKeyword' }
  --       hl.CmpItemKindCopilot = { fg = "#6CC644" }
  --
  --       hl.Folded = {
  --         -- bg = '#15161e'
  --         bg = c.bg_dark
  --       }
  --
  --       hl.LspInlayHint = {
  --         fg = c.comment,
  --         italic = true
  --       }
  --
  --       -- Statusline
  --       hl.StatusLineModeNormal = { fg = c.orange }
  --       hl.StatusLineLSPNames = { bg = c.bg, fg = c.purple }
  --     end
  --   },
  --   config = function(_, opts)
  --     require('tokyonight').setup(opts)
  --
  --     -- vim.api.nvim_command("colorscheme tokyonight")
  --   end
  -- }
}
