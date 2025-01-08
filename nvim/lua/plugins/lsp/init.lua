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
      -- local vue_language_server_path = require("mason-registry").get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
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
            analysis = {
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
            root_dir = require('lspconfig').util.root_pattern('nuxt.config.ts', 'quasar.config.js', 'quasar.config.ts'),
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
            -- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
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
                -- https://github.com/yioneko/vtsls/issues/148
                tsserver = {
                  globalPlugins = {
                    -- Use volar for only .vue files and tsserver for .ts and .js files.
                    {
                      name = "@vue/typescript-plugin",
                      location = require("mason-registry").get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server",
                      languages = { "vue" },
                      -- configNamespace = "typescript",
                      -- enableForWorkspaceTypeScriptVersions = true,
                    }

                  }
                }
              },
              typescript = {
                inlayHints = {
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = 'literals' },
                  variableTypes = { enabled = true },
                },
                suggest = {
                  completeFunctionCalls = true,
                },
              },
              javascript = {
                inlayHints = {
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = 'literals' },
                  variableTypes = { enabled = true },
                },
                suggest = {
                  completeFunctionCalls = true,
                },
              }
            },
            -- before_init = function(params, config)
            --   -- https://github.com/yioneko/vtsls/issues/148#issuecomment-2119744901
            --   -- checks whether vue is installed before adding the plugin.
            --   local result = vim.system(
            --     { "npm", "query", "#vue" },
            --     { cwd = params.workspaceFolders[1].name, text = true }
            --   ):wait()
            --   if result.stdout ~= "[]" then
            --     -- Use volar for only .vue files and tsserver for .ts and .js files.
            --     -- local vue_language_server_path = require('mason-registry').get_package('vue-language-server')
            --     -- :get_install_path() .. '/node_modules/@vue/language-server'
            --     local vuePluginConfig = {
            --       name = "@vue/typescript-plugin",
            --       location = vue_language_server_path,
            --       languages = { "vue" },
            --       configNamespace = "typescript",
            --       enableForWorkspaceTypeScriptVersions = true,
            --     }
            --     table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
            --   end
            -- end
          },
          emmet_language_server = {
            -- no need for vue as volar already provides emmet support
            filetypes = { "css", "eruby", "html", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
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
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      local blink = require('blink.cmp')
      -- if ok then
      --   capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities() or {})
      -- end

      -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
      -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
      -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      local servers = opts.servers

      -- Server setup
      local function setup(server)
        -- local server_opts = vim.tbl_deep_extend('error', {
        --   -- capabilities = vim.deepcopy(capabilities),
        --   capabilities = capabilities,
        -- }, servers[server] or {})
        local server_opts = blink.get_lsp_capabilities(servers[server] or {})

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
      for server, _ in pairs(servers) do
        -- if server_opts then
        --   server_opts = server_opts == true and {} or server_opts
          -- run manual setup if this is a server that cannot be installed with mason-lspconfig
          if not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        -- end
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
