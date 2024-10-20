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
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      local vue_language_server_path = require('mason-registry').get_package('vue-language-server'):get_install_path() ..
        '/node_modules/@vue/language-server'

      return {
        servers = {
          cssls = {},
          gopls = {
            settings = {
              gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                staticcheck = true,
                semanticTokens = true,
              }
            },
          },
          -- eslint = {
          --   settings = {
          --     format = false,
          --   }
          -- },
          -- pylsp = {
          --   settings = {
          --     pylsp = {
          --       plugins = {
          --         pycodestyle = { enabled = false },
          --         pyflakes = { enabled = false },
          --         pylint = { enabled = false },
          --         flake8 = { enabled = false },
          --         jedi_completion = { enabled = true },
          --         jedi_hover = { enabled = true },
          --         jedi_references = { enabled = true },
          --         jedi_signature_help = { enabled = true },
          --         jedi_symbols = { enabled = true },
          --         mccabe = { enabled = false },
          --         preload = { enabled = false },
          --         pydocstyle = { enabled = false },
          --         rope_completion = { enabled = true },
          --         rope_rename = { enabled = true },
          --         yapf = { enabled = false },
          --       }
          --     }
          --   }
          -- },
          basedpyright = {
            disableOrganizeImports = false, -- use keymap instead
            analysis= {
              useLibraryCodeForTypes = true,
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
            }
          },
          -- ruff_lsp = {},
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
          -- rust_analyzer = {
          --   settings = {
          --     ["rust-analyzer"] = {
          --       inlayHints = {
          --         chainingHints = { enable = true },
          --       },
          --       procMacro = { enable = true },
          --       cargo = { allFeatures = true },
          --       -- checkOnSave = {
          --       --   command = "clippy",
          --       --   extraArgs = { "--no-deps" },
          --       -- },
          --     }
          --   },
          -- },
          tailwindcss = {
            filetypes = { "astro", "astro-markdown", "blade", "django-html", "htmldjango", "edge",
              "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex",
              "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim",
              "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascriptreact", "reason",
              "rescript", "typescriptreact", "vue", "svelte" },
            root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts')
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
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = true,
    event = "VeryLazy", -- Or `LspAttach`
    config = function()
      require('tiny-inline-diagnostic').setup({
        options = {
          -- show_source = true,
          multiple_diag_under_cursor = true,
          format = function(diagnostic)
            local level = vim.diagnostic.severity[diagnostic.severity]
            return string.format("%s %s [%s]", require('config.icons').diagnostics[level], diagnostic.message, diagnostic.source)
          end,
          -- Enable diagnostic message on all lines.
          -- multilines = true,
          -- show_all_diags_on_cursorline = true,
          -- overwrite_events = { "DiagnosticChanged" },
        }
      })
    end
  }
}
