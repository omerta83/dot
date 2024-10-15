local M = {}

M.root_patterns = { ".git", "lua" }

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
          return vim.uri_to_fname(ws.uri)
        end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.get_dap_adapter_path(name)
  return require('mason-registry').get_package(name):get_install_path()
end

function M.theme_colors()
  if vim.g.colors_name == 'carbonfox' then
    local palette = require('nightfox.palette').load('carbonfox')
    -- Returns a table with the colors of the theme compatible with tokyonight
    local colors = {}
    colors.bg = palette.bg1
    colors.bg_highlight = palette.bg2
    colors.bg_dark = palette.bg0
    colors.teal = palette.cyan.base
    colors.red = palette.red.base
    colors.cyan = palette.cyan.base
    colors.orange = palette.orange.base
    colors.green = palette.green.base
    colors.purple = palette.magenta.base
    colors.blue = palette.blue.base
    colors.blue1 = palette.blue.base
    colors.dark5 = palette.black.base
    return colors
  elseif vim.g.colors_name == 'catppuccin' then
    return require('catppuccin.palettes').get_palette()
  elseif vim.g.colors_name == 'tokyonight' then
    return require('tokyonight.colors').setup({ style = 'night' })
  end
  return {}
end

function M.map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

return M
