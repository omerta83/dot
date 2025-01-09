local components = require('plugins/lualine/components')
local M = {}

M.term = {
  sections = {
    lualine_a = {
      components.mode,
      -- components.logo,
      -- components.space,
    },
    lualine_b = {
      components.term,
    },
  },
  filetypes = { "toggleterm" }
}

return M
