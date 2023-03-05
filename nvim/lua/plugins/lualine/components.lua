local icons = require('config.icons')
local separator = { left = icons.misc.SeparatorLeft, right = icons.misc.SeparatorRight }

local function getLspNames()
  local msg = "No Active Lsp"
  local icon = icons.misc.Gear .. " "
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  local clientNames = ''
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      -- return icon .. client.name
      clientNames = clientNames .. (clientNames == '' and '' or '') .. client.name
    end
  end
  return icon .. (clientNames ~= '' and clientNames or msg)
end


local M = {
  vim_icon = {
    function()
      return icons.misc.Apple
    end,
    separator = separator,
    color = { bg = "#313244", fg = "#80A7EA" },
  },
  space = {
    function()
      return " "
    end,
    color = { bg = "#11111f" },
    padding = 0
  },
  filename = {
    'filename',
    path = 1,
    symbols = icons.file,
    color = { bg = "#80A7EA", fg = "#242735" },
    separator = separator,
  },
  filetype = {
    "filetype",
    icon_only = true,
    colored = true,
    color = { bg = "#313244" },
    separator = separator,
  },
  fileformat = {
    "fileformat",
    color = { bg = "#b4befe", fg = "#313244" },
    separator = separator,
  },
  encoding = {
    "encoding",
    color = { bg = "#313244", fg = "#80A7EA" },
    separator = separator,
  },
  branch = {
    "branch",
    icon = "",
    color = { bg = "#a6e3a1", fg = "#313244" },
    separator = separator,
  },
  diff = {
    "diff",
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
    color = { bg = "#313244", fg = "#313244" },
    separator = separator,
  },
  modes = {
    "mode",
    fmt = function(str)
      return str:sub(1, 1)
    end,
    color = { bg = "#fab387", fg = "#000000" },
    separator = separator,
  },
  lsp_symbols = {
    function() return require("nvim-navic").get_location() end,
    cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
  },
  dia = {
    "diagnostics",
    color = { bg = "#313244", fg = "#80A7EA" },
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
    color = { bg = "#f38ba8", fg = "#1e1e2e" },
  }
}

return M
