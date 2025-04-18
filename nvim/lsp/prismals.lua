--- Install with `pnpm i -g @prisma/language-server`
--- Mason version does not seem to work well
---@type vim.lsp.Config
return {
  cmd = { "prisma-language-server", "--stdio" },
  filetypes = { "prisma" },
  root_markers = { ".git", "package.json" },
  settings = {
    prisma = {
      prismaFmtBinPath = "",
    },
  }
}
