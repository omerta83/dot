local M = {}

M.theme = function()
  if vim.g.colors_name == 'kanagawa' then
    local theme = require('kanagawa.colors').setup().theme
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
      a = { fg = theme.syn.keyword },
      b = { fg = theme.syn.keyword },
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
    local Color = require('nightfox.lib.color')
    local s = require('nightfox.spec').load('carbonfox')
    local p = s.palette
    local base = Color.from_hex(s.bg0)

    local function fade(color, amount)
      amount = amount or 0.5
      return base:blend(Color.from_hex(color), amount):to_css()
    end

    return {
      normal = {
        a = { fg = p.blue.base, gui = "bold" },
        b = { fg = p.blue.base },
        c = { fg = s.fg2 },
      },

      insert = {
        a = { fg = p.green.base, gui = "bold" },
        b = { fg = p.green.base },
      },

      command = {
        a = { fg = p.yellow.base, gui = "bold" },
        b = { fg = p.yellow.base },
      },

      visual = {
        a = { fg = p.magenta.base, gui = "bold" },
        b = { fg = p.magenta.base },
      },

      replace = {
        a = { fg = fade(p.red.base), gui = "bold" },
        b = { fg = fade(p.red.base) },
      },

      terminal = {
        a = { fg = p.orange.base, gui = "bold" },
        b = { fg = p.orange.base },
      },

      inactive = {
        a = { fg = p.blue.base },
        b = { fg = s.fg3, gui = "bold" },
        c = { fg = s.syntax.comment },
      },
    }
  end
end

return M
