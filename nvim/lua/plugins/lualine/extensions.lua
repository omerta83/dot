local components = require(('plugins/lualine/components'))
local icons = require('config.icons')
local M = {}

local function term_str()
  return string.format(
    "%s %s %s Terminal %s %s",
    vim.b.toggle_number,
    icons.misc.VertSeparator,
    icons.misc.Term,
    icons.misc.VertSeparator,
    vim.o.shell
  )
end

M.term = {
  sections = {
    lualine_a = {
      components.modes,
      components.logo,
      components.space,
    },
    lualine_b = {
      {
        term_str,
        separator = {
          left = require('config.icons').misc.SeparatorLeft,
          right = require('config.icons').misc.SeparatorRight
        }
      }
    },
  },
  filetypes = { "toggleterm" }
}

return M
