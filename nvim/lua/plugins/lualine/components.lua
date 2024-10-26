local icons = require('config.icons')
-- local colors = require('util').theme_colors()
-- local separator = { left = icons.misc.SeparatorLeft, right = icons.misc.SeparatorRight }

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

local function show_searchcount()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == "" then
    return ""
  end
  local search = vim.fn.searchcount({ maxcount = 0 })
  return last_search .. "(" .. search.current .. "/" .. search.total .. ")"
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
    -- separator = separator,
    -- color = { bg = colors.bg_highlight, fg = colors.teal },
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
    -- color = { bg = colors.blue, fg = colors.bg_dark },
    -- separator = separator,
  },
  filetype = {
    "filetype",
    icon_only = true,
    colored = true,
    icon = { align = 'right' }
    -- color = { bg = colors.bg_highlight },
    -- separator = separator,
  },
  fileformat = {
    "fileformat",
    -- color = { bg = colors.dark5, fg = colors.bg_dark },
    -- separator = separator,
    cond = function()
      -- only show when not unix
      return vim.bo.fileformat ~= "unix"
    end,
  },
  encoding = {
    "encoding",
    -- color = { bg = colors.bg_highlight, fg = colors.blue1 },
    -- separator = separator,
    cond = function()
      -- only show when not utf-8
      return vim.bo.fileencoding ~= "utf-8"
    end,
  },
  branch = {
    "branch",
    -- icon = "",
    icon = icons.git.head,
    -- color = { bg = colors.cyan, fg = colors.bg_dark },
    -- separator = separator,
  },
  diff = {
    "diff",
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
    -- color = { bg = colors.bg_highlight },
    -- separator = separator,
  },
  modes = {
    "mode",
    fmt = function()
      -- return str:sub(1, 1)
      return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
    end,
    -- separator = separator,
  },
  tasks = {
    "overseer",
    -- separator = separator,
  },
  -- lsp_symbols = {
  --   function() return require("nvim-navic").get_location() end,
  --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
  -- },
  dia = {
    "diagnostics",
    -- color = { bg = colors.bg_highlight },
    -- separator = separator,
    symbols = {
      error = icons.diagnostics.ERROR,
      warn = icons.diagnostics.WARN,
      info = icons.diagnostics.INFO,
      hint = icons.diagnostics.HINT,
    },
  },
  lsp = {
    function()
      return getLspNames()
    end,
    -- separator = separator,
  },
  term = {
    term_str,
    -- separator = separator,
    -- color = { fg = colors.green }
  },
  searchcount = {
    show_searchcount,
    icon = icons.misc.Search,
    -- color = { fg = colors.green, },
  },
  marco_recording = {
    show_macro_recording,
    icon = icons.misc.Record,
    -- color = { fg = colors.red, },
  },
}

return M
