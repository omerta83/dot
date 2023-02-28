local util = require('util')
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },
  {
    "williamboman/mason-lspconfig",
    cmd = "Mason",
    init = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          -- "codelldb", -- for rust debug
          "cssls",
          "jsonls",
          "gopls",
          "lua_ls",
          "rust_analyzer",
          "tsserver",
          "vuels",
          "tailwindcss"
        }
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      }
    },
    keys = {
      { "gD",         vim.lsp.buf.declaration,    desc = "Go to declaration [LSP]",    noremap = true,      silent = true },
      { "gd",         vim.lsp.buf.definition,     desc = "Go to definition [LSP]",     noremap = true,      silent = true },
      { "gi",         vim.lsp.buf.implementation, desc = "Go to implementation [LSP]", noremap = true,      silent = true },
      { "<c-s>",      vim.lsp.buf.signature_help, desc = "Signature help [LSP]",       mode = { "i", "n" }, noremap = true, silent = true },
      { "K",          vim.lsp.buf.hover,          desc = "Hover" },
      { "<leader>cd", vim.diagnostic.open_float,  desc = "Line Diagnostics" },
      {
        "]d",
        function()
          vim.diagnostic.goto_next()
        end,
        desc = "Next Diagnostic"
      },
      {
        "[d",
        function()
          vim.diagnostic.goto_prev()
        end,
        desc = "Prev Diagnostic"
      },
      {
        "]e",
        function()
          vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Next Error"
      },
      {
        "[e",
        function()
          vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Prev Error"
      },
      {
        "]w",
        function()
          vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.WARN })
        end,
        desc = "Next Warning"
      },
      {
        "[w",
        function()
          vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN })
        end,
        desc = "Prev Warning"
      },
      {
        "<leader>cf",
        function()
          vim.lsp.buf.format {
            async = true,
          }
        end,
        desc = "Format buffer [LSP]",
        noremap = true,
        silent = true
      },
      { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action [LSP]" },
    },
    config = function()
      local on_attach = function(_, bufnr)
        --Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      end

      -- Set up completion using nvim_cmp with LSP source
      local capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- Server setup
      local lsp = require('lspconfig')

      require("typescript").setup({
        server = {
          on_attach = util.on_attach(function(client, bufnr)
            if client.name == "tsserver" then
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>",
                { buffer = bufnr, desc = "Organize Imports" })
              vim.keymap.set("n", "<leader>cr", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })
              vim.keymap.set("n", "<leader>ci", "<cmd>TypescriptAddMissingImports<CR>",
                { desc = "Add Missing Imports", buffer = bufnr })
              vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<CR>",
                { desc = "Remove Unused", buffer = bufnr })
            end
            on_attach(client, bufnr)
          end),
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
          capabilities = capabilities,
          -- cmd = { "typescript-language-server", "--stdio" },
        }
      })

      lsp.jsonls.setup {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      }
      -- lsp.sourcekip.setup {
      --   on_attach = on_attach
      -- }
      lsp.lua_ls.setup {
        on_attach = util.on_attach(on_attach),
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },

            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            telemetry = {
              enable = false
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
                continuation_indent = "2"
              }
            }
          },
        },
      }
      lsp.gopls.setup {
        on_attach = util.on_attach(on_attach),
      }
      lsp.vuels.setup {
        -- cmd = { 'vls' },
        filetypes = { 'vue' },
        on_attach = util.on_attach(function(client, bufnr)
          -- Need this line for vetur document formatting
          client.server_capabilities.documentFormattingProvider = true
          on_attach(client, bufnr)
        end),
        capabilities = capabilities,
        settings = {
          vetur = {
            completion = {
              autoImport = true,
              useScaffoldSnippets = true
            },
            format = {
              defaultFormatter = {
                js = "prettier",
                ts = "prettier",
              }
            },
            validation = {
              template = true,
              script = true,
              style = true,
              templateProps = true,
              interpolation = false
            },
            experimental = {
              templateInterpolationService = true
            }
          }
        },
      }
      lsp.html.setup {
        init_options = {
          provideFormatter = true
        }
      }
      lsp.tailwindcss.setup {
        on_attach = util.on_attach(on_attach),
        -- cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascriptreact", "reason", "rescript", "typescriptreact", "vue", "svelte" },
        root_dir = lsp.util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts'),
        tailwindCSS = {
          emmetCompletions = true,
        }
      }

      -- Diagnostic symbols in the sign column (gutter)
      -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      local signs = require('config.icons').diagnostics
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
          underline = true,
          update_in_insert = false,
          virtual_text = { spacing = 4, prefix = "●" },
          severity_sort = true,
        }
      )

      -- Set border for hover popup
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = 'rounded',
          title = " " .. require('config.icons').misc.Bell .. "Hover "
        }
      )

      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●'
        },
        update_in_insert = true,
        float = {
          source = "always", -- Or "if_many"
          border = 'rounded',
          title = " " .. require('config.icons').diagnostics.Warn .. "Diagnostic "
        },
      })
    end
  },
  {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    config = function()
      local rt = require('rust-tools')
      local codelldb = require('util').get_dap_adapter_path('codelldb')
      rt.setup {
        server = {
          on_attach = require('util').on_attach(function(_, bufnr)
            -- Hover actions
            -- vim.keymap.set("n", "gk", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end),
        },
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            }
          }
        },
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb .. '/extension/adapter/codelldb', codelldb .. '/extension/lldb/lib/liblldb.dylib'),
        },
      }
    end
  },
}
