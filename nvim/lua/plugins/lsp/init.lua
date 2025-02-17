local icons = require('config.icons')

return {
  -- JSON schemas.
  {
    'b0o/SchemaStore.nvim',
    -- Loaded by jsonls when needed.
    version = false,
    lazy = true,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local servers = require('plugins.lsp.servers')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Server setup
      local function setup(server)
        local server_opts = vim.tbl_deep_extend('error', {
          capabilities = capabilities
        }, servers[server] or {})

        require('lspconfig')[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end
      local ensure_installed = {}
      for server, _ in pairs(servers) do
        -- run manual setup if this is a server that cannot be installed with mason-lspconfig
        if not vim.tbl_contains(all_mslp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
    end
  },

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

  {
    'yioneko/nvim-vtsls',
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },

  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    opts = {
      fvm = true,
      widget_guides = {
        enabled = true,
      },
      dev_log = {
        open_cmd = "10split",
        focus_on_open = false,
      },
      lsp = {
        color = {
          enabled = true,
          virtual_text_str = "󱓻",
        },
        settings = {
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand '$HOME/.pub-cache',
            -- vim.fn.expand '$HOME/fvm/versions', -- flutter-tools should automatically exclude your SDK.
          },
        }
      }
    }
  },
}
