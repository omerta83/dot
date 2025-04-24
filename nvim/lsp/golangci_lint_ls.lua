---@brief
---
--- Combination of both lint server and client
---
--- https://github.com/nametake/golangci-lint-langserver
--- https://github.com/golangci/golangci-lint
---
---
--- Installation of binaries needed is done via
---
--- ```
--- mise use -g golangci-lint-langserver@latest
--- mise use -g golangci-lint@latest
--- ```
---@type vim.lsp.Config
return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod' },
  init_options = {
    command = { 'golangci-lint', 'run', '--output.json.path=stdout', '--show-stats=false' },
  },
  root_markers = {
    '.golangci.yml',
    '.golangci.yaml',
    '.golangci.toml',
    '.golangci.json',
    'go.work',
    'go.mod',
    '.git',
  },
}
