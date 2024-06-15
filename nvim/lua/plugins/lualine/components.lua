local icons = require('config.icons')
local colors = require('util.init').theme_colors()
local separator = { left = icons.misc.SeparatorLeft, right = icons.misc.SeparatorRight }

local function getLspNames()
  local msg = "No Active Lsp"
  local icon = icons.misc.Gear .. " "
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
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
      clientNames = clientNames .. (clientNames == '' and '' or '') .. client.name:gsub("[-_].*$", "") -- remove any characters after - or _
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

local M = {
  logo = {
    function()
      return icons.misc.Robot
    end,
    separator = separator,
    color = { bg = colors.bg_highlight, fg = colors.teal },
  },
  space = {
    function()
      return " "
    end,
    color = { bg = colors.bg },
    padding = 0
  },
  filename = {
    'filename',
    path = 1,
    symbols = icons.file,
    color = { bg = colors.blue, fg = colors.bg_dark },
    separator = separator,
  },
  filetype = {
    "filetype",
    icon_only = true,
    colored = true,
    color = { bg = colors.bg_highlight },
    separator = separator,
  },
  fileformat = {
    "fileformat",
    color = { bg = colors.dark5, fg = colors.bg_dark },
    separator = separator,
    cond = function()
      -- only show when not unix
      return vim.bo.fileformat ~= "unix"
    end,
  },
  encoding = {
    "encoding",
    color = { bg = colors.bg_highlight, fg = colors.blue1 },
    separator = separator,
    cond = function()
      -- only show when not utf-8
      return vim.bo.fileencoding ~= "utf-8"
    end,
  },
  branch = {
    "branch",
    -- icon = "",
    icon = icons.git.head,
    color = { bg = colors.cyan, fg = colors.bg_dark },
    separator = separator,
  },
  diff = {
    "diff",
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
    color = { bg = colors.bg_highlight },
    separator = separator,
  },
  modes = {
    "mode",
    fmt = function(str)
      return str:sub(1, 1)
    end,
    color = { bg = colors.orange, fg = colors.bg_dark },
    separator = separator,
  },
  -- lsp_symbols = {
  --   function() return require("nvim-navic").get_location() end,
  --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
  -- },
  dia = {
    "diagnostics",
    color = { bg = colors.bg_highlight },
    separator = separator,
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
  },
  lsp = {
    function()
      return getLspNames()
    end,
    separator = separator,
    color = { bg = colors.purple, fg = colors.bg_dark },
  },
  term = {
    term_str,
    separator = separator,
    color = { fg = colors.green }
  }
}

return M
