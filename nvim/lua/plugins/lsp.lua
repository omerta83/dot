return {
  {
    "mason-org/mason.nvim", cmd = "Mason", opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        -- Go
        "golangci_lint_ls",
        "gopls",

        -- Python
        -- "basedpyright",
        "pyrefly",
        "ruff",
        "ty",

        -- Web development
        -- "biome",
        "cssls",
        "emmet_language_server",
        "eslint",
        "html",
        "prismals",
        "svelte",
        "tailwindcss",
        "vtsls",
        "vue_ls", -- Add Vue support to vtsls

        -- Other languages
        "jsonls",
        "lua_ls",
        "postgres_lsp",
        -- "copilot",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      -- Not in Mason
      vim.lsp.enable('dartls')
      vim.lsp.enable('phpantom')
      -- vim.lsp.enable('tsgo')
      -- vim.lsp.enable("svelte")

      -- local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      -- Ensure all servers are installed
      mason_lspconfig.setup(opts)
    end,
  }
}
