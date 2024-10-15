-- local util = require('util')
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
      -- {
      --   "b0o/SchemaStore.nvim",
      --   version = false, -- last release is way too old
      -- },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- {
      --   "hrsh7th/cmp-nvim-lsp",
      --   cond = function()
      --     return util.has("nvim-cmp")
      --   end,
      -- },
      -- "marilari88/twoslash-queries.nvim"
    },
    opts = function()
      local vue_language_server_path = require('mason-registry').get_package('vue-language-server'):get_install_path() ..
      '/node_modules/@vue/language-server'

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
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
            }
          }
        },
        servers = {
          cssls = {},
          gopls = {
            settings = {
              gopls = {
                semanticTokens = true,
              }
            }
          },
          pylsp = {
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = { enabled = false },
                  pyflakes = { enabled = false },
                  pylint = { enabled = false },
                  flake8 = { enabled = false },
                  jedi_completion = { enabled = true },
                  jedi_hover = { enabled = true },
                  jedi_references = { enabled = true },
                  jedi_signature_help = { enabled = true },
                  jedi_symbols = { enabled = true },
                  mccabe = { enabled = false },
                  preload = { enabled = false },
                  pydocstyle = { enabled = false },
                  rope_completion = { enabled = true },
                  rope_rename = { enabled = true },
                  yapf = { enabled = false },
                }
              }
            }
          },
          ruff_lsp = {},
          -- pyright = {
          --   disableOrganizeImports = false, -- use keymap instead
          --   analysis = {
          --     useLibraryCodeForTypes = true,
          --     autoSearchPaths = true,
          --     diagnosticMode = "workspace",
          --     autoImportCompletions = true,
          --   },
          -- },
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
          -- Vue 2.x
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
          -- Vue 3.x
          volar = {
            -- on_attach = function(client, bufnr)
            --   require("twoslash-queries").attach(client, bufnr)
            -- end,
            root_dir = require('lspconfig').util.root_pattern('nuxt.config.ts', 'quasar.config.js'),
            -- filetypes = {
            --   'vue',
            -- },
            init_options = {
              typescript = {
                tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
              },
              vue = {
                -- auto start tsserver in the background
                hybridMode = false,
              },
            }
          },
          vtsls = {
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                -- Use volar for only .vue files and tsserver for .ts and .js files.
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = vue_language_server_path,
                      languages = { 'vue' }
                    }
                  }
                }
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
              }
            }
          },
          emmet_language_server = {
            filetypes = { "css", "eruby", "html", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "vue" }
          },
          lua_ls = {
            single_file_support = true,
            on_init = function(client)
              local path = client.workspace_folders
                and client.workspace_folders[1]
                and client.workspace_folders[1].name
              print(path)
              if
                not path
                or not (
                  vim.uv.fs_stat(path .. '/.luarc.json')
                  or vim.uv.fs_stat(path .. '/.luarc.jsonc')
                )
              then
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                  Lua = {
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
                })
                client.notify(
                  vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
                  { settings = client.config.settings }
                )
              end

              return true
            end,
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
          rust_analyzer = {
            settings = {
              ["rust-analyzer"] = {
                inlayHints = {
                  chainingHints = { enable = true },
                },
                procMacro = { enable = true },
                cargo = { allFeatures = true },
                -- checkOnSave = {
                --   command = "clippy",
                --   extraArgs = { "--no-deps" },
                -- },
              }
            },
          },
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
          markdown_oxide = {},
        },
      }
    end,
    config = function(_, opts)
      -- Set up completion using nvim_cmp with LSP source
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities() or {})
      end

      -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
      -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      -- setup keymaps
      require('plugins.lsp.utils').on_attach(function(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      -- setup vetur document formatting
      require('plugins.lsp.utils').on_attach(function(client, buffer)
        if client.name == 'vuels' then
          -- Need this line for vetur document formatting
          client.server_capabilities.documentFormattingProvider = true
        end
      end)

      -- inlay hints
      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        require('plugins.lsp.utils').on_attach(function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            vim.defer_fn(function()
              inlay_hint(buffer, true)
            end, 500)
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
        if opts.setup and opts.setup[server] then
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
      -- local signs = icons.diagnostics
      -- for type, icon in pairs(signs) do
      --   local hl = "DiagnosticSign" .. type
      --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      -- end
      if type(opts.diagnostics.signs) ~= "boolean" then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
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

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>m", "<cmd>Mason<CR>", desc = "Mason" } },
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
  --   "pmizio/typescript-tools.nvim",
  --   -- dependencies = "marilari88/twoslash-queries.nvim",
  --   -- ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  --   event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
  --   opts = {
  --     -- on_attach = function(client, bufnr)
  --     --   require("twoslash-queries").attach(client, bufnr)
  --     -- end,
  --     settings = {
  --       tsserver_file_preferences = {
  --         includeInlayParameterNameHints = 'literals',
  --         includeInlayVariableTypeHints = true,
  --         includeInlayFunctionLikeReturnTypeHints = true,
  --       },
  --       complete_function_calls = true,
  --       include_completions_with_insert_text = true,
  --     },
  --   },
  -- },

  {
    'yioneko/nvim-vtsls',
    event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
  },

  {
    "akinsho/flutter-tools.nvim",
    event = { 'BufReadPre *.dart', 'BufNewFile *.dart' },
    opts = {
      fvm = true
    }
  },

  -- {
  --   "luckasRanarison/tailwind-tools.nvim",
  --   ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  --   opts = {
  --     document_color = {
  --       enabled = true, -- can be toggled by commands
  --       kind = "inline", -- "inline" | "foreground" | "background"
  --       inline_symbol = "󰝤 ", -- only used in inline mode
  --       debounce = 200, -- in milliseconds, only applied in insert mode
  --     },
  --     conceal = {
  --       enabled = false, -- can be toggled by commands
  --       symbol = "󱏿", -- only a single character is allowed
  --       highlight = { -- extmark highlight options, see :h 'highlight'
  --         fg = "#38BDF8",
  --       },
  --     },
  --     custom_filetypes = {}
  --   }
  -- },

  {
    "olexsmir/gopher.nvim",
    ft = { "go", "gomod" },
    config = function()
      require("gopher").setup {
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "~/go/bin/gotests", -- also you can set custom command path
          impl = "impl",
          iferr = "iferr",
        },
      }
    end
  }
}
