-- Install with `brew install lua-language-server`
-- Do not use Mason version as it does not work well
---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  -- NOTE: These will be merged with the configuration file.
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      format = { enable = true },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },
      telemetry = {
        enable = false
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
    },
  },
}
