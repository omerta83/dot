local function theme()
  -- local colors = {
  --   darkgray = "#16161d",
  --   gray = "#727169",
  --   innerbg = nil,
  --   outerbg = "#16161D",
  --   normal = "#7e9cd8",
  --   insert = "#98bb6c",
  --   visual = "#ffa066",
  --   replace = "#e46876",
  --   command = "#e6c384",
  -- }
  local colors = require('util').theme_colors()
  return {
    inactive = {
      a = { fg = colors.fg_dark, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
    visual = {
      a = { fg = colors.purple, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
    replace = {
      a = { fg = colors.red, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
    normal = {
      a = { fg = colors.blue1, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
    insert = {
      a = { fg = colors.green, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
    command = {
      a = { fg = colors.blue, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg_dark, bg = colors.bg },
      c = { fg = colors.fg_dark, bg = colors.bg },
    },
  }
end
return {
  "nvim-lualine/lualine.nvim",
  -- event = "VeryLazy",
  lazy = false,
  opts = function()
    local components = require('plugins/lualine/components')

    -- Custom theme
    -- local colors = require('util').theme_colors()
    -- local custom_theme = require('lualine.themes.carbonfox')
    -- custom_theme.normal.c.bg = colors.bg
    -- custom_theme.normal.c.fg = colors.bg
    -- custom_theme.inactive = { c = { fg = colors.fg, bg = colors.bg } }

    return {
      options = {
        theme = theme(),
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
          -- components.tasks,
        },
        lualine_c = {
          components.space,
          components.tasks,
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
          components.lsp,
        },
        lualine_z = {
          -- components.dia,
          -- components.lsp,
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
