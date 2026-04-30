-- https://github.com/AJenbo/phpantom_lsp
-- Install with Mason

-- @type vim.lsp.Config
return {
  -- cmd = { 'phpantom_lsp' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
}
