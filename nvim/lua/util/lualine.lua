local M = {}

M.theme = function()
  if vim.g.colors_name == 'kanso' then
    local theme = require('kanso.colors').setup().theme
    local kanagawa = {}

    kanagawa.normal = {
      a = { fg = theme.syn.fun },
      b = { fg = theme.syn.fun },
      c = { fg = theme.ui.fg },
    }

    kanagawa.insert = {
      a = { fg = theme.diag.ok },
      b = { fg = theme.diag.ok },
    }

    kanagawa.command = {
      a = { fg = theme.syn.operator },
      b = { fg = theme.syn.operator },
    }

    kanagawa.visual = {
      a = { fg = theme.ui.bg_search },
      b = { fg = theme.ui.bg_search },
    }

    kanagawa.replace = {
      a = { fg = theme.syn.constant },
      b = { fg = theme.syn.constant },
    }

    kanagawa.inactive = {
      a = { fg = theme.ui.fg_dim },
      b = { fg = theme.ui.fg_dim, gui = "bold" },
      c = { fg = theme.ui.fg_dim },
    }

    if vim.g.kanagawa_lualine_bold then
      for _, mode in pairs(kanagawa) do
        mode.a.gui = "bold"
      end
    end

    return kanagawa
  else
    return vim.g.colors_name
  end
end

return M
