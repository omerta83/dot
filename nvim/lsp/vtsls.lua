-- Install with `pnpm install -g @vtsls/language-server`

local jsts_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'literals' },
    variableTypes = { enabled = true },
  },
}

---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  root_markers = { 'tsconfig.json', 'jsonconfig.json', 'package.json', '.git' },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      -- https://github.com/yioneko/vtsls/issues/148
      tsserver = {
        globalPlugins = {
          -- Use volar for only .vue files and tsserver for .ts and .js files.
          {
            name = "@vue/typescript-plugin",
            -- vue-language-server installed with brew
            location = '/usr/local/opt/vue-language-server/libexec/lib/node_modules/@vue/language-server',
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          }
        }
      }
    },
    typescript = jsts_settings,
    javascript = jsts_settings,
  },
}
