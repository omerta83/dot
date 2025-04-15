---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json" },
  -- root_markers = { 'nuxt.config.ts', 'quasar.config.js', 'quasar.config.ts' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
    },
    vue = {
      hybridMode = false
    }
  }
}
