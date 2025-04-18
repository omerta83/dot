-- Install with: `pnpm i -g vscode-langservers-extracted` or mason
-- https://github.com/neovim/nvim-lspconfig/blob/d3ad666b7895f958d088cceb6f6c199672c404fe/lua/lspconfig/configs/eslint.lua#L70
local lsp = vim.lsp

local function fix_all(opts)
  opts = opts or {}

  local eslint_lsp_client = vim.lsp.get_clients({ bufnr = opts.bufnr, name = 'eslint' })[1]
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, {}, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  end

  request(0, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(0),
        version = lsp.util.buf_versions[0],
      },
    },
  })
end

---@type vim.lsp.Config
return {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'graphql',
    'vue',
  },
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
  },
  settings = {
    validate = 'on',
    packageManager = nil,
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeActionOnSave = { enable = false, mode = 'all' },
    format = false,
    quiet = false,
    onIgnoredFiles = 'off',
    options = {},
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(params, config)
    -- Set the workspace folder setting for correct search of tsconfig.json files etc.
    config.settings.workspaceFolder = {
      uri = params.rootPath,
      name = vim.fn.fnamemodify(params.rootPath, ':t'),
    }
  end,
  ---@type table<string, lsp.Handler>
  handlers = {
    ['eslint/openDoc'] = function(_, params)
      vim.ui.open(params.url)
      return {}
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('LSP[eslint]: Probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('LSP[eslint]: Unable to load ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  },
  on_attach = function()
    vim.api.nvim_buf_create_user_command(
      0,
      'EslintFixAll',
      function()
        fix_all { sync = true, bufnr = 0 }
      end,
      { desc = 'Fix all eslint problems for this buffer' }
    )
  end
}
