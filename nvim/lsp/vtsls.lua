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
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tsconfig.json', 'jsonconfig.json' },
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
            -- location = require("mason-registry").get_package("vue-language-server"):get_install_path() ..
            location = require('util').get_mason_pkg_path('vue-language-server') ..
              "/node_modules/@vue/language-server",
            languages = { "vue" },
            -- configNamespace = "typescript",
            -- enableForWorkspaceTypeScriptVersions = true,
          }

        }
      }
    },
    typescript = jsts_settings,
    javascript = jsts_settings,
  },
}
