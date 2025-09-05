local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
    '/vue-language-server' .. '/node_modules/@vue/language-server'
return {
  -- filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  -- Only for vue, tsgo for typescript
  filetypes = { 'vue' },
  settings = {
    complete_function_calls = true,
    vtsls = {
      -- autoUseWorkspaceTsdk = true,
      experimental = {
        -- Inlay hint truncation.
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      -- https://github.com/yioneko/vtsls/issues/148
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
            configNamespace = "typescript",
            -- enableForWorkspaceTypescriptVersions = true,
          }
        }
      }
    },
    typescript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        variableTypes = { enabled = true },
      },
    },
    javascript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        variableTypes = { enabled = true },
      },

    },
  }
}
