local M = {}

M.root_patterns = { ".git", "lua" }

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client.name == 'vuels' then
        -- Need this line for vetur document formatting
        client.server_capabilities.documentFormattingProvider = true
      end

      on_attach(client, buffer)
    end,
  })
end

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
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
  if vim.g.colors_name == 'gruvbox' then
    return require('gruvbox.palette').get_base_colors('dark', 'hard')
  elseif vim.g.colors_name == 'catppuccin' then
    return require('catppuccin.palettes').get_palette()
  elseif vim.g.colors_name == 'tokyonight' then
    return require('tokyonight.colors').setup({ style = 'night' })
  end
  return {}
end

return M
