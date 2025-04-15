local M = {}

-- M.root_patterns = { ".git", "lua" }
--
-- function M.get_root()
--   ---@type string?
--   local path = vim.api.nvim_buf_get_name(0)
--   path = path ~= "" and vim.loop.fs_realpath(path) or nil
--   ---@type string[]
--   local roots = {}
--   if path then
--     for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
--       local workspace = client.config.workspace_folders
--       local paths = workspace and vim.tbl_map(function(ws)
--           return vim.uri_to_fname(ws.uri)
--         end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
--       for _, p in ipairs(paths) do
--         local r = vim.loop.fs_realpath(p)
--         if path:find(r, 1, true) then
--           roots[#roots + 1] = r
--         end
--       end
--     end
--   end
--   table.sort(roots, function(a, b)
--     return #a > #b
--   end)
--   ---@type string?
--   local root = roots[1]
--   if not root then
--     path = path and vim.fs.dirname(path) or vim.loop.cwd()
--     ---@type string?
--     root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
--     root = root and vim.fs.dirname(root) or vim.loop.cwd()
--   end
--   ---@cast root string
--   return root
-- end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.get_mason_pkg_path(name)
  return require('mason-registry').get_package(name):get_install_path()
end

function M.map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

local function escape_wildcards(path)
  -- Escape all potentially problematic special characters
  -- Covers:
  -- - Wildcards and pattern matching: [ ] ? * $ ( ) ^ % . + - ~
  -- - Escape character: \
  -- - Shell special characters: ` ' " ; | & < >
  -- - Whitespace: %s (spaces, tabs, etc.)
  -- The gsub function replaces any matches with the same character preceded by a backslash
  return path:gsub('([' .. vim.pesc('[]?*$()^%.+-~') .. '\\`\'";|&<>%s])', '\\%1')
end

local nvim_eleven = vim.fn.has 'nvim-0.11' == 1
function M.tbl_flatten(t)
  --- @diagnostic disable-next-line:deprecated
  return nvim_eleven and vim.iter(t):flatten(math.huge):totable() or vim.tbl_flatten(t)
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

function M.search_ancestors(startpath, func)
  if nvim_eleven then
    vim.validate('func', func, 'function')
  end
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.root_pattern(...)
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.uv.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

return M
