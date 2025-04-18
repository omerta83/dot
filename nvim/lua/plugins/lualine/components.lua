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

local function getLspNames()
  local msg = "No Active Lsp"
  local buf_ft = vim.bo.filetype
  local separator = icons.misc.VertSeparator
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return msg
  end
  local clientNames = ''
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      clientNames = clientNames ..
        (clientNames == '' and '' or separator) .. client.name:gsub("[-_].*$", "") -- remove any characters after - or _
    end
  end
  return clientNames ~= '' and clientNames or msg
end

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
    getLspNames,
    icon = icons.misc.Gear,
  },
  term = {
    term_str,
  },
}

return M
