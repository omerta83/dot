return {
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
