return {
  {
    "mason-org/mason.nvim", cmd = "Mason", opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        "basedpyright",
        "biome",
        "cssls",
        "emmet_language_server",
        "eslint",
        "golangci_lint_ls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "postgres_lsp",
        "prismals",
        "ruff",
        "tailwindcss",
        "vtsls",
        "vue_ls",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      -- Custom server configurations
      local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
          '/vue-language-server' .. '/node_modules/@vue/language-server'
      vim.lsp.config('biome', {
        filetypes = {
          'astro',
          'css',
          'graphql',
          'javascript',
          'javascriptreact',
          'json',
          'jsonc',
          'svelte',
          'typescript',
          'typescript.tsx',
          'typescriptreact',
        },
      })
      -- vim.lsp.config('eslint', {
      --   filetypes = {
      --     -- Use biome for other filetypes
      --     'vue',
      --   },
      -- })
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            validate = { enable = true },
            format = {
              enable = true,
            },
            schemas = require('schemastore').json.schemas(),
          },
        },
      })
      vim.lsp.config('lua_ls', {
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
      })
      vim.lsp.config('tailwindcss', {
        filetypes = {
          "css",
          "gohtml",
          "haml",
          "html",
          "javascriptreact",
          "less",
          "php",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "svelte",
          "typescriptreact",
          "vue",
        },
      })
      vim.lsp.config('vtsls', {
        -- filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        -- Only for vue, tsgo for typescript
        filetypes = { 'vue' },
        settings = {
          complete_function_calls = true,
          vtsls = {
            -- autoUseWorkspaceTsdk = true,
            experimental = {
              -- Inlay hint truncation.
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
            -- https://github.com/yioneko/vtsls/issues/148
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                  -- enableForWorkspaceTypescriptVersions = true,
                }
              }
            }
          },
          typescript = {
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
            },
          },
          javascript = {
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
            },

          },
        }
      })

      -- Not in Mason
      vim.lsp.enable('dartls')
      vim.lsp.enable('tsgo')

      -- local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      -- Ensure all servers are installed
      mason_lspconfig.setup(opts)
    end,
  }
}
