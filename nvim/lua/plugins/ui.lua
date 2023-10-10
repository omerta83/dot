return {
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    main = 'ibl',
    opts = {
      indent = {
        char = "▏",
        priority = 50,
      },
      scope = {
        enabled = true,
        char = "▏",
        show_start = false,
        show_end = false
      },
      whitespace = {
        remove_blankline_trail = true
      },
      exclude = {
        filetypes = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" }
      }
      -- filetype_exclude = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" },
      -- filetype = require('nvim-treesitter.configs').get_ensure_installed_parsers(), -- keep in sync with nvim-treesitter
      -- use_treesitter = true,
      -- show_trailing_blankline_indent = false,
      -- show_first_indent_level = false,
      -- show_end_of_line = true,
      -- show_current_context = true,
      -- context_char = "▏",
      -- space_char_blankline = " ",
      -- char_priority = 50, -- fix for nvim-ufo integration
    },
    configs = function(_, opts)
      require('ibl').setup(opts)
      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
    end
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    -- lazy = true,
    -- event = "VeryLazy",
    event = { "BufReadPost" },
    opts = {
      input = {
        win_options = {
          winhighlight = 'FloatBorder:LspFloatWinBorder',
          winblend = 5,
        },
      },
      select = {
        backend = { 'fzf_lua', 'builtin' },
        trim_prompt = false,
        fzf_lua = {
          winopts = {
            height = 0.6,
            width = 0.5,
          },
        },
        builtin = {
          mappings = { ['q'] = 'Close' },
          win_options = {
            -- Same UI as the input field.
            winhighlight = 'FloatBorder:LspFloatWinBorder,DressingSelectIdx:LspInfoTitle,MatchParen:Ignore',
            winblend = 5,
          },
        },
        get_config = function(opts)
          if opts.kind == 'codeaction' or opts.kind == 'codelens' then
            return {
              backend = 'builtin',
              builtin = {
                relative = 'cursor',
                max_height = 0.33,
                min_height = 5,
                max_width = 0.40,
              },
            }
          end
        end,
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
      require("util.init").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.api.nvim_buf_line_count(0) > 1000 then
            vim.b.navic_lazy_update_context = true
          end
        end,
      })
    end,
    opts = function()
      return {
        separator = "  ",
        highlight = true,
        depth_limit = 5,
        icons = require('config.icons').kinds
      }
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
