local util = require('util')
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      -- { 'simrat39/rust-tools.nvim' },
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return util.has("nvim-cmp")
        end,
      },
    },
    keys = {
      { "gD", vim.lsp.buf.declaration,    desc = "Go to declaration [LSP]",    noremap = true, silent = true },
      { "gd", vim.lsp.buf.definition,     desc = "Go to definition [LSP]",     noremap = true, silent = true },
      { "gi", vim.lsp.buf.implementation, desc = "Go to implementation [LSP]", noremap = true, silent = true },
      {
        "<c-s>",
        vim.lsp.buf.signature_help,
        desc = "Signature help [LSP]",
        mode = { "i", "n" },
        noremap = true,
        silent = true
      },
      { "K",          vim.lsp.buf.hover,         desc = "Hover" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
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
          require('plugins.lsp.format').format("documentFormatting")
        end,
        desc = "Format Document",
      },
      {
        "<leader>cf",
        function()
          require('plugins.lsp.format').format("documentRangeFormatting")
        end,
        desc = "Format Range",
        mode = "v"
      },
      { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action [LSP]" },
      { "<Leader>cl", "<CMD>LspRestart<CR>", desc = "Restart LSP" },
    },
    opts = function()
      return {
        inlay_hints = { enabled = true },
        diagnostics = {
          underline = true,
          severity_sort = true,
          virtual_text = {
            spacing = 4,
            prefix = '●'
          },
          float = {
            source = "always", -- Or "if_many"
            border = 'rounded',
            title = " " .. require('config.icons').diagnostics.Warn .. "Diagnostic "
          },
        },
        servers = {
          cssls = {},
          gopls = {},
          jsonls = {
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
          },
          html = {
            filetypes = {
              'html'
            }
          },
          prismals = {},
          volar = {
            root_dir = require('lspconfig').util.root_pattern('tsconfig.json'),
            filetypes = {
              'vue',
            },
            init_options = {
              typescript = {
                tsdk = "~/.pnpm/global/5/node_modules/typescript/lib"
              }
            }
          },
          vuels = {
            root_dir = require('lspconfig').util.root_pattern('jsconfig.json'),
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
          },
          lua_ls = {
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
          },
          tsserver = {
            single_file_support = false,
            settings = {
              completions = {
                completeFunctionCalls = true,
              },
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          },
          rust_analyzer = {},
          -- rust_analyzer = {
          --   server = {
          --     settings = {
          --       ["rust-analyzer"] = {
          --         procMacro = { enable = true },
          --         cargo = { allFeatures = true },
          --         checkOnSave = {
          --           command = "clippy",
          --           extraArgs = { "--no-deps" },
          --         },
          --       }
          --     },
          --   },
          -- },
          tailwindcss = {
            filetypes = { "astro", "astro-markdown", "blade", "django-html", "htmldjango", "edge",
              "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex",
              "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim",
              "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascriptreact", "reason",
              "rescript", "typescriptreact", "vue", "svelte" },
            root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts',
              'postcss.config.js', 'postcss.config.ts')
          },
        },
        setup = {
          tsserver = function(_, opts)
            util.on_attach(function(client, bufnr)
              if client.name == "tsserver" then
                vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>",
                  { buffer = bufnr, desc = "Organize Imports" })
                vim.keymap.set("n", "<leader>cr", "<cmd>TypescriptRenameFile<CR>",
                  { desc = "Rename File", buffer = bufnr })
                vim.keymap.set("n", "<leader>ci", "<cmd>TypescriptAddMissingImports<CR>",
                  { desc = "Add Missing Imports", buffer = bufnr })
                vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<CR>",
                  { desc = "Remove Unused", buffer = bufnr })
              end
            end)
            require("typescript").setup({ server = opts })
            return true
          end,
        },
      }
    end,
    config = function(_, opts)
      -- Set up completion using nvim_cmp with LSP source
      local capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- Server setup
      local servers = opts.servers
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        -- If a setup method is provided, use it instead
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        end

        require('lspconfig')[server].setup(server_opts)
      end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if this is a server that cannot be installed with mason-lspconfig
          if not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })

      -- Diagnostic symbols in the sign column (gutter)
      local signs = require('config.icons').diagnostics
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Set border for hover popup
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = 'rounded',
          title = " " .. require('config.icons').misc.Bell .. " Hover "
        }
      )
    end
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.dart_format,
          -- nls.builtins.formatting.gofmt,
          nls.builtins.formatting.jq,                                                                                    -- json
          nls.builtins.formatting.rome.with({ args = { "format", "--indent-style", "space", "--write", "$FILENAME" } }), -- typescript and javascript
          -- nls.builtins.formatting.eslint,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.rustywind, -- tailwind css classes
          nls.builtins.formatting.ruff,      -- python
          -- nls.builtins.formatting.rustfmt, -- rust
          -- nls.builtins.formatting.stylua,

          -- nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      ui = {
        border = "single",
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.cmd([[setlocal nocursorline]])
        end
      })
    end
  },
  {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    config = function()
      require('rust-tools').setup {
        server = {
          settings = {
            ["rust-analyzer"] = {
              procMacro = { enable = true },
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            }
          },
        },
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(
            require('util').get_dap_adapter_path('codelldb') .. '/extension/adapter/codelldb',
            require('util').get_dap_adapter_path('codelldb') .. '/extension/lldb/lib/liblldb.dylib'),
        },
      }
    end
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    config = true
  }
}
