local icons = require('config.icons')

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>m", "<cmd>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      -- linters and formatters
      ensure_installed = { 'biome', 'golangci-lint', 'oxlint', 'ruff', 'rustywind' }, -- not an option from mason.nvim
      ui = {
        border = "single",
        icons = {
          package_installed = icons.folder.default,
          package_pending = icons.folder.open,
          package_uninstalled = icons.folder.empty,
        },
      },
    },
    config = function(_, opts)
      local mason = require('mason')
      mason.setup(opts)

      -- Disable cursorline for Mason files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.cmd([[setlocal nocursorline]])
        end
      })

      -- TODO: merge this with mason-lspconfig configuration
      -- require('lua.plugins.lsp.helper').mason_install(opts.ensure_installed)

      -- User command to install all Mason packages
      -- Adapted from https://github.com/williamboman/mason.nvim/issues/130#issuecomment-1217773757
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {
        desc = "Install all Mason packages",
      })
    end
  },
}
