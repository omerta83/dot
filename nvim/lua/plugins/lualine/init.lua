return {
  "nvim-lualine/lualine.nvim",
  -- event = { "BufRead", "BufNewFile" },
  event = "VeryLazy",
  opts = function()
    local components = require('plugins/lualine/components')
    local colors = require('util.init').theme_colors()

    -- Custom theme
    local wonderful_night = require('lualine.themes.tokyonight')
    wonderful_night.normal.a.bg = colors.bg
    wonderful_night.normal.c.bg = colors.bg

    return {
      options = {
        -- theme = 'catppuccin',
        theme = wonderful_night,
        -- theme = 'tokyonight',
        component_separators = '',
        section_separators = '',
        globalstatus = true,
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
        },
        lualine_c = {
        --   components.lsp_symbols,
        },
        lualine_x = {
          components.space,
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
