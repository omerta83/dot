local M = {}
M.cssls = {}
M.gopls = {
  settings = {
    gopls = {
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      semanticTokens = true,
    }
  },
}
M.basedpyright = {
  disableOrganizeImports = false, -- use keymap instead
  analysis = {
    useLibraryCodeForTypes = true,
    autoSearchPaths = true,
    diagnosticMode = "workspace",
    autoImportCompletions = true,
  }
}
M.jsonls = {
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
M.html = {
  filetypes = {
    'html'
  }
}
M.prismals = {}
-- Vue 2.x
M.vuels = {
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
}
-- Vue 3.x
M.volar = {
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
}
M.vtsls = {
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
            -- location = require("mason-registry").get_package("vue-language-server"):get_install_path() ..
            location = require('util').get_mason_pkg_path('vue-language-server') ..
              "/node_modules/@vue/language-server",
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
}
M.emmet_language_server = {
  -- no need for vue as volar already provides emmet support
  filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "typescriptreact" },
}
M.lua_ls = {
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
        keywordSnippet = "Both",
        callSnippet = "Both",
        showWord = "Disable",  -- already done by completion plugin
        workspaceWord = false, -- already done by completion plugin
        postfix = ".",         -- useful for `table.insert` and the like
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
}
M.tailwindcss = {
  filetypes = { "gohtml", "haml", "html", "php", "css", "less", "postcss", "sass", "scss", "stylus", "javascriptreact", "typescriptreact", "vue", "svelte" },
  root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts')
}
M.dockerls = {}
M.markdown_oxide = {}

return M
