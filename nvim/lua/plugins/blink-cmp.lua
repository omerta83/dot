return {
  {
    'saghen/blink.cmp',
    enabled = true,
    event = "InsertEnter",
    version = '*',
    opts = {
      cmdline = {
        enabled = false
      },
      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        kind_icons = require('config.icons').kinds,
      },

      completion = {
        list = {
          selection = { preselect = false, auto_insert = false },
          max_items = 20,
        },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          scrollbar = false,
          border = 'rounded',
          draw = {
            -- treesitter = { "lsp" },
            columns = {
              { 'label',    'label_description', gap = 1 },
              { 'kind_icon' },
              -- { 'source_name' },
            },
            components = {
              label = { width = { max = 30 } },
              label_description = require('util.cmp').blink_label_description,
              -- customize the drawing of kind icons
              kind_icon = require('util.cmp').blink_kind_icon,
            }
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
          }
        },
        ghost_text = {
          enabled = false,
        },
      },

      -- experimental signature help support
      signature = { enabled = true },

      sources = {
        default = function()
          local sources = { 'lsp', 'buffer' }
          local ok, node = pcall(vim.treesitter.get_node)

          if ok and node then
            if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
              table.insert(sources, 'path')
            end
            if node:type() ~= 'string' then
              table.insert(sources, 'snippets')
            end
          end

          return sources
        end,
        per_filetype = { sql = { 'dadbod' } },
        providers = {
          dadbod = { module = "vim_dadbod_completion.blink" },
        }
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
      -- Extend neovim's client capabilities with the completion ones.
      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
    end
  }
}
