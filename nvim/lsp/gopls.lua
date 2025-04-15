---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      semanticTokens = true,
    }
  },
}
