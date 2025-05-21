---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "gohtml",
    "haml",
    "html",
    "php",
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    "stylus",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.mjs",
  },
  -- Disable single file support so that tailwind is not attached
  -- when no root directory found
  workspace_required = true,
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
    },
  },
}
