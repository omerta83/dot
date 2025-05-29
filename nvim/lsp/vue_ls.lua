local function get_typescript_server_path(root_dir)
  local project_roots = vim.fs.find('node_modules', { path = root_dir, upward = true, limit = math.huge })
  for _, project_root in ipairs(project_roots) do
    local typescript_path = project_root .. '/typescript'
    local stat = vim.loop.fs_stat(typescript_path)
    if stat and stat.type == 'directory' then
      return typescript_path .. '/lib'
    end
  end
  return ''
end

-- https://github.com/vuejs/language-tools/blob/master/packages/language-server/lib/types.ts
local volar_init_options = {
  typescript = {
    tsdk = '',
  },
  vue = {
    hybridMode = true
  }
}
---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json" },
  -- root_markers = { 'nuxt.config.ts', 'quasar.config.js', 'quasar.config.ts', '' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  init_options = volar_init_options,
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == '' then
      ---@diagnostic disable-next-line: inject-field
      config.init_options.typescript.tsdk = get_typescript_server_path(config.root_dir)
    end
  end,
}
