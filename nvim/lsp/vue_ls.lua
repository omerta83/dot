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

---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  -- https://github.com/vuejs/language-tools/wiki/Neovim
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
      if #clients == 0 then
        vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'Request tsserver',
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        if r ~= nil then
          local response_data = { { id, r.body } }
          ---@diagnostic disable-next-line: param-type-mismatch
          client:notify('tsserver/response', response_data)
        end
      end)
    end
  end,
  -- https://github.com/vuejs/language-tools/blob/master/packages/language-server/lib/types.ts
  init_options = {
    typescript = {
      tsdk = '',
    }
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == '' then
      ---@diagnostic disable-next-line: inject-field
      config.init_options.typescript.tsdk = get_typescript_server_path(config.root_dir)
      -- config.init_options.typescript.tsdk = '/Applications/Visual Studio Code.app/Contents/Resources/app/extensions/node_modules/typescript/lib'
    end
  end,
}
