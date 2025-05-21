local icons = require('config.icons')

-- https://www.reddit.com/r/neovim/s/ZbFDWKLIZd
-- local mode_map = {
--   n = '(˵•̀ ᴗ -)',
--   nt = '(˵•̀ ᴗ -)',
--   i = '(•̀ - •́ )',
--   R = '( •̯́ ₃ •̯̀)',
--   v = '( -_・)σ',
--   V = '( -_・)σ',
--   no = 'Σ(°△°ꪱꪱ)',
--   ['\22'] = '( -_・)σ',
--   t = ' (⌐■_■) ',
--   ['!'] = 'Σ(°△°ꪱꪱ)',
--   c = 'Σ(°△°ꪱꪱ)',
--   s = '(´ ▽｀) ',
-- }

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

local M = {
  logo = {
    function()
      return icons.misc.Robot
    end,
  },
  space = {
    function()
      return " "
    end,
    padding = 0
  },
  filename = {
    'filename',
    path = 1,
    symbols = icons.file,
  },
  filetype = {
    "filetype",
    icon_only = true, -- file statuses
    colored = true,
    separator = "",
    padding = { left = 0, right = 1 },
  },
  fileformat = {
    "fileformat",
    cond = function()
      -- only show when not unix
      return vim.bo.fileformat ~= "unix"
    end,
  },
  encoding = {
    "encoding",
    cond = function()
      -- only show when not utf-8
      return vim.bo.fileencoding ~= "utf-8"
    end,
  },
  branch = {
    "branch",
    icon = icons.git.head,
    color = { fg = '#FF5D62' }, -- Kanagawa peachRed
  },
  diff = {
    "diff",
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
  },
  mode = {
    "mode",
    fmt = function(str)
      return str:sub(1, 1)
      -- return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
    end,
  },
  dia = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.ERROR,
      warn = icons.diagnostics.WARN,
      info = icons.diagnostics.INFO,
      hint = icons.diagnostics.HINT,
    },
  },
  lsp = {
    'lsp_status',
    icon = icons.misc.Gear,
    symbols = {
      separator = icons.misc.VertSeparator,
    }
  },
  term = {
    term_str,
  },
}

return M
