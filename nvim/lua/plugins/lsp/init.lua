local util = require('util')
local icons = require('config.icons')
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "pmizio/typescript-tools.nvim",
      -- {
      --   "b0o/SchemaStore.nvim",
      --   version = false, -- last release is way too old
      -- },
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
      { "gr", vim.lsp.buf.references,     desc = "Go to references [LSP]",     noremap = true, silent = true },
      { "gi", vim.lsp.buf.implementation, desc = "Go to implementation [LSP]", noremap = true, silent = true },
      {
        "<c-s>",
        vim.lsp.buf.signature_help,
        desc = "Signature help [LSP]",
        mode = { "i", "n" },
        noremap = true,
        silent = true
      },
      -- { "K",          vim.lsp.buf.hover,         desc = "Hover" },
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
      { "<Leader>ca", vim.lsp.buf.code_action,   desc = "Code Action [LSP]", mode = { "n", "v" } },
      { "<Leader>cl", "<CMD>LspRestart<CR>",     desc = "Restart LSP" },
    },
    opts = function()
      return {
        inlay_hints = { enabled = false },
        diagnostics = {
          underline = true,
          severity_sort = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = '●'
          },
          float = {
            source = "always", -- Or "if_many"
            border = 'rounded',
            title = " " .. icons.diagnostics.Warn .. "Diagnostic "
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
            root_dir = require('lspconfig').util.root_pattern('nuxt.config.ts', 'quasar.config.js'),
            filetypes = {
              'vue',
              'typescript'
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
          -- emmet_ls = {
          --   init_options = {
          --     jsx = {
          --       options = {
          --         ["output.selfClosingStyle"] = 'xhtml'
          --       }
          --     }
          --   }
          -- },
          lua_ls = {
            single_file_support = true,
            settings = {
              Lua = {
                hint = {
                  enable = true,
                  arrayIndex = "Disable"
                },
                completion = {
                  workspaceWord = true,
                  callSnippet = "Both",
                },
                diagnostics = {
                  disable = { "incomplete-signature-doc", "trailing-space" },
                  groupSeverity = {
                    strong = "Warning",
                    strict = "Warning",
                  },
                },
                workspace = {
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
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
            settings = {
              separate_diagnostic_server = true,
              tsserver_path = "~/.pnpm/global/5/node_modules/typescript/lib",
              tsserver_file_preferences = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              complete_function_calls = true,
            },
          },
          -- rust_analyzer = {},
          tailwindcss = {
            filetypes = { "astro", "astro-markdown", "blade", "django-html", "htmldjango", "edge",
              "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex",
              "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim",
              "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascriptreact", "reason",
              "rescript", "typescriptreact", "vue", "svelte" },
            root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts',
              'postcss.config.js', 'postcss.config.ts', 'postcss.config.cjs')
          },
          dockerls = {},
          -- formatters and linters
          -- biome = {},
        },
        setup = {
          tsserver = function(_, opts)
            -- local client_name = "typescript-tools"
            -- local client_name = "tsserver"
            util.on_attach(function(client, bufnr)
              -- if client.name == client_name then
              vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>",
                { buffer = bufnr, desc = "Organize Imports" })
              vim.keymap.set("n", "<leader>cr", "<cmd>TSToolsRenameFile<CR>",
                { desc = "Rename File", buffer = bufnr })
              vim.keymap.set("n", "<leader>td", "<cmd>TSToolsGoToSourceDefinition<CR>",
                { desc = "Go To Source Definition", buffer = bufnr })
              vim.keymap.set("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<CR>",
                { desc = "Add Missing Imports", buffer = bufnr })
              vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<CR>",
                { desc = "Remove Unused", buffer = bufnr })
              vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRemoveUnusedImports<CR>",
                { desc = "Remove Unused Imports", buffer = bufnr })
              vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>",
                { desc = "Fix All Errors", buffer = bufnr })
              -- end
            end)
            -- require("typescript").setup({ server = opts })
            require("typescript-tools").setup(opts)
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

      -- inlay hints
      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        util.on_attach(function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            inlay_hint(buffer, true)
          end
        end)
      end

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

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end
      -- local available = mlsp.get_available_servers()
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if this is a server that cannot be installed with mason-lspconfig
          if not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
      -- require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      -- require("mason-lspconfig").setup_handlers({ setup })

      -- Diagnostic symbols in the sign column (gutter)
      local signs = icons.diagnostics
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
          title = " " .. icons.misc.Bell .. " Hover "
        }
      )
    end
  },

  -- formatters
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'biome' },
        typescript = { 'biome' },
        ["javascript.jsx"] = { "biome", "rustywind" },
        javascriptreact = { "biome", "rustywind" },
        ["typescript.tsx"] = { 'biome', 'rustywind' },
        typescriptreact = { 'biome', 'rustywind' },
        vue = { 'prettier', 'rustywind' },
        lua = { 'stylua' },
        python = { 'ruff' },
        go = { 'gofmt' },
      }
    },
  },

  -- linter
  -- Copied from https://github.com/stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/lint.lua
  {
    "mfussenegger/nvim-lint",
    ft = {
      "javascript",
      "javascript.jsx",
      "javascriptreact",
      "lua",
      "python",
      "rst",
      "typescript",
      "typescript.tsx",
      "typescriptreact",
      "vue",
    },
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        ["javascript.jsx"] = { "eslint" },
        javascriptreact = { "eslint" },
        lua = { "luacheck" },
        python = { "mypy", "pylint" },
        rst = { "rstlint" },
        typescript = { "eslint" },
        ["typescript.tsx"] = { "eslint" },
        typescriptreact = { "eslint" },
        vue = { "eslint" },
      },
      linters = {},
    },
    config = function(_, opts)
      local uv = vim.uv or vim.loop
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft
      for k, v in pairs(opts.linters) do
        lint.linters[k] = v
      end
      local timer = assert(uv.new_timer())
      local DEBOUNCE_MS = 500
      local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = aug,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          timer:stop()
          timer:start(
            DEBOUNCE_MS,
            0,
            vim.schedule_wrap(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                  lint.try_lint(nil, { ignore_errors = true })
                end)
              end
            end)
          )
        end,
      })
      lint.try_lint(nil, { ignore_errors = true })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
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
      require('mason').setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.cmd([[setlocal nocursorline]])
        end
      })
    end
  },
  -- {
  --   'simrat39/rust-tools.nvim',
  --   ft = "rust",
  --   config = function()
  --     require('rust-tools').setup {
  --       server = {
  --         settings = {
  --           ["rust-analyzer"] = {
  --             procMacro = { enable = true },
  --             cargo = { allFeatures = true },
  --             checkOnSave = {
  --               command = "clippy",
  --               extraArgs = { "--no-deps" },
  --             },
  --           }
  --         },
  --       },
  --       dap = {
  --         adapter = require('rust-tools.dap').get_codelldb_adapter(
  --           util.get_dap_adapter_path('codelldb') .. '/extension/adapter/codelldb',
  --           util.get_dap_adapter_path('codelldb') .. '/extension/lldb/lib/liblldb.dylib'),
  --       },
  --     }
  --   end
  -- },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    config = true
  }
}
