return {
  -- {
  --   'echasnovski/mini.snippets',
  --   version = false,
  --   dependencies = 'rafamadriz/friendly-snippets',
  --   config = function()
  --     local gen_loader = require('mini.snippets').gen_loader
  --     require('mini.snippets').setup({
  --       snippets = {
  --         -- Load snippets based on current language by reading files from
  --         -- "snippets/" subdirectories from 'runtimepath' directories.
  --         gen_loader.from_lang(),
  --       },
  --     })
  --   end
  -- },

  {
    'saghen/blink.cmp',
    enabled = true,
    event = "InsertEnter",
    -- dependencies = 'echasnovski/mini.snippets',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      -- snippets = {
      --   preset = 'mini_snippets',
      -- },
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
          selection = { preselect = false, auto_insert = true },
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
        default = { "lsp", "path", "snippets", "buffer", "dadbod" },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" }
        },
        -- Disable cmdline for now
        cmdline = {},
      },
    }
  }
}
