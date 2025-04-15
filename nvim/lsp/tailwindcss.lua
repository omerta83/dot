---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "gohtml", "haml", "html", "php", "css", "less", "postcss", "sass", "scss", "stylus", "javascriptreact", "typescriptreact", "vue", "svelte" },
  root_dir = require('util').root_pattern('tailwind.config.js', 'tailwind.config.ts'),
}
