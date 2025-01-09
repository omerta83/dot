local icons = require('config.icons')

-- https://www.reddit.com/r/neovim/s/ZbFDWKLIZd
local mode_map = {
  n = '(˵•̀ ᴗ -)',
  nt = '(˵•̀ ᴗ -)',
  i = '(•̀ - •́ )',
  R = '( •̯́ ₃ •̯̀)',
  v = '( -_・)σ',
  V = '( -_・)σ',
  no = 'Σ(°△°ꪱꪱ)',
  ['\22'] = '( -_・)σ',
  t = ' (⌐■_■) ',
  ['!'] = 'Σ(°△°ꪱꪱ)',
  c = 'Σ(°△°ꪱꪱ)',
  s = '(´ ▽｀) ',
}

local function getLspNames()
  local msg = "No Active Lsp"
  local icon = icons.misc.Gear .. " "
  -- local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local buf_ft = vim.bo.filetype
  -- local clients = vim.lsp.get_active_clients()
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return msg
  end
  local clientNames = ''
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      -- return icon .. client.name
      clientNames = clientNames ..
        (clientNames == '' and '' or '') .. client.name:gsub("[-_].*$", "") -- remove any characters after - or _
    end
  end
  return icon .. (clientNames ~= '' and clientNames or msg)
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

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
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
    -- color = { bg = colors.bg },
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
    -- icon = { align = 'right' }
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
  tasks = {
    "overseer",
    -- separator = separator,
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
    -- separator = separator,
  },
  term = {
    term_str,
  },
  searchcount = {
    'searchcount',
  },
  -- marco_recording = {
  --   show_macro_recording,
  --   icon = icons.misc.Record,
  -- },
}

return M
