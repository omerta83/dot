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

  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {
      compile = false,
      keywordStyle = { italic = false },
      overrides = function(colors)
        local theme = colors.theme
        local palette = colors.palette
        return {
          -- Shortcut to transparent background
          NoneBg                             = { bg = "none" },
          CursorLine                         = { link = "NoneBg" },
          StatusLine                         = { link = "NoneBg" },
          NormalFloat                        = { link = "NoneBg" },
          FloatBorder                        = { link = "NoneBg" },
          FloatTitle                         = { link = "NoneBg" },

          CursorLineNr                       = { fg = palette.dragonGray2 },

          -- FzfLuaBackdrop = { bg = theme.ui.bg },
          -- FzfLuaNormal = { bg = theme.ui.bg },
          FzfLuaBackdrop                     = { link = "NoneBg" },
          FzfLuaNormal                       = { link = "NoneBg" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark                         = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal                         = { bg = theme.ui.bg, fg = theme.ui.fg_dim },
          MasonNormal                        = { bg = theme.ui.bg, fg = theme.ui.fg_dim },

          -- Autocompletion popup
          Pmenu                              = { fg = theme.ui.shade0, bg = "NONE" }, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel                           = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar                          = { bg = theme.ui.bg_m1 },
          PmenuThumb                         = { bg = theme.ui.bg_p2 },

          LspReferenceWrite                  = { underline = false },

          -- Blink
          BlinkCmpMenuBorder                 = { link = "FloatBorder" },
          -- BlinkCmpMenuSelection     = { fg = theme.syn.comment, bg = 'none' },
          BlinkCmpDocBorder                  = { link = "FloatBorder" },

          -- LspInlayHint = { bg = theme.ui.nontext, fg = theme.ui.bg_m3 },
          LspInlayHint                       = { fg = theme.ui.nontext },
          ["@lsp.typemod.function.readonly"] = { bold = false },
          -- Make this treesitter hl the same as lsp's semantic highlighting
          -- ["@variable"] = { link = "Constant" },
          -- ["@type"] = { link = "Constant" },
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
      background = {
        dark = "dragon",
        light = "wave"
      }
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      -- Drop the priority of semantic tokens below treesitter (100)
      -- -- vim.highlight.priorities.semantic_tokens = 95
      -- vim.api.nvim_command("colorscheme kanagawa")
    end
  },

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      keywordStyle = { italic = false },
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            }
          }
        }
      },
      background = {
        dark = "zen",
        light = "pearl"
      },
      overrides = function()
        return {
          -- Shortcut to transparent background
          NoneBg             = { bg = "none" },
          FloatBorder        = { link = "NoneBg" },
          CursorLine         = { link = "NoneBg" },

          FzfLuaBackdrop     = { link = "NoneBg" },
          FzfLuaNormal       = { link = "NoneBg" },

          LspReferenceWrite  = { underline = false },

          -- -- Autocompletion popup
          Pmenu              = { link = "NoneBg" }, -- add `blend = vim.o.pumblend` to enable transparency
          -- PmenuSel           = { fg = "NONE" },
          -- PmenuSbar          = { bg = "NONE" },
          -- PmenuThumb         = { bg = "NONE" },

          -- Blink
          BlinkCmpMenuBorder = { link = "FloatBorder" },
          -- BlinkCmpMenuSelection     = { fg = theme.syn.comment, bg = 'none' },
          BlinkCmpDocBorder  = { link = "FloatBorder" },
        }
      end
    },
    config = function(_, opts)
      require('kanso').setup(opts)
      vim.api.nvim_command("colorscheme kanso")
    end
  },
}
