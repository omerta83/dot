return {
  "nvim-lualine/lualine.nvim",
  -- event = "VeryLazy",
  lazy = false,
  opts = function()
    local components = require('plugins/lualine/components')
    local colors = require('util').theme_colors()

    -- Custom theme
    local custom_theme = require('lualine.themes.carbonfox')
    custom_theme.normal.c.bg = colors.bg

    return {
      options = {
        theme = custom_theme,
        component_separators = '',
        section_separators = '',
        globalstatus = true,
        -- refresh = {
        --   statusline = 0, -- avoid flickering when refresh
        -- },
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha", "TelescopePrompt", "mason", "lspinfo", "fzf" }
        },
      },
      sections = {
        lualine_a = {
          components.modes,
          -- components.logo,
          components.space,
        },
        lualine_b = {
          components.filename,
          components.filetype,
          components.space,
          components.branch,
          -- components.diff,
          components.tasks,
        },
        lualine_c = {
        --   components.lsp_symbols,
        },
        lualine_x = {
          components.marco_recording,
          components.space,
          components.searchcount,
        },
        lualine_y = {
          components.encoding,
          components.fileformat,
          components.space,
        },
        lualine_z = {
          -- components.dia,
          components.lsp,
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {
        require('plugins.lualine.extensions').term,
      },
    }
  end,
}
