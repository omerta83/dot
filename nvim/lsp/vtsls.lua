-- Install with `pnpm install -g @vtsls/language-server`

local jsts_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'literals' },
    variableTypes = { enabled = true },
  },
}

-- vue-language-server installed with brew
local function vue_ls_location()
  if vim.fn.system('arch') == 'arm64' then -- Apple Sillicon
    return '/opt/homebrew/opt/vue-language-server/libexec/lib/node_modules/@vue/language-server'
  end
  -- Intel Mac
  return '/usr/local/opt/vue-language-server/libexec/lib/node_modules/@vue/language-server'
end

---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  root_markers = { 'tsconfig.json', 'jsonconfig.json', 'package.json', '.git' },
  settings = {
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      typescript = {
        globalTsdk = '/Applications/Visual Studio Code.app/Contents/Resources/app/extensions/node_modules/typescript/lib'
      },
      -- https://github.com/yioneko/vtsls/issues/148
      tsserver = {
        globalPlugins = {
          -- Use volar for only .vue files and tsserver for .ts and .js files.
          {
            name = "@vue/typescript-plugin",
            location = vue_ls_location(),
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
