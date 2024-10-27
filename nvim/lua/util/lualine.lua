local M = {}

M.theme = function()
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

return M
