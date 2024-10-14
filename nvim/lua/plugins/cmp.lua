return {
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    enabled = false, -- disabled as blink.cmp being used
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- autocomplete and its sources
  {
    "hrsh7th/nvim-cmp",
    enabled = false, -- disabled as blink.cmp being used
    event = { "InsertEnter", "CmdlineEnter" },
    version = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      'hrsh7th/cmp-cmdline',
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local defaults = require("cmp.config.default")()
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping(function()
            -- Dismiss copilot if visible
            local copilot = require('copilot.suggestion')
            if copilot.is_visible() then
              copilot.dismiss()
            end
            cmp.close()
          end, { 'i', 's' }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          {
            name = 'nvim_lsp',
            group_index = 1,
            option = {
              markdown_oxide = {
                keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
              }
            }
          },
          { name = "luasnip", group_index = 2 },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
            group_index = 2
          },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            local has_tailwind_tools, tailwind_tools = pcall(require, "tailwind-tools.cmp")
            if has_tailwind_tools then
              vim_item = tailwind_tools.lspkind_format(entry, vim_item)
            end
            local icons = require('config.icons').kinds
            if icons[vim_item.kind] then
              vim_item.kind = icons[vim_item.kind] .. ' ' .. vim_item.kind
            end
            return vim_item
          end,
        },
        -- experimental = {
        --   ghost_text = {
        --     hl_group = "CmpGhostText",
        --   },
        -- },
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        window = {
          documentation = cmp.config.window.bordered({
            winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
          }),
          completion = cmp.config.window.bordered({
            winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
          }),
        },
      })

      vim.keymap.set("i", vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), function()
        require("cmp").complete()
      end)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' }
      --   }
      -- })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
        -- {
        --   { name = 'path' }
        -- },
          {
            { name = 'cmdline' }
          }
        )
      })
    end
  },

  {
    'saghen/blink.cmp',
    enabled = true,
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',

    version = 'v0.*',

    opts = {
      keymap = {
        select_prev = { '<Up>', '<C-p>' },
        select_next = { '<Down>', '<C-n>' },
        accept = '<CR>',
      },
      highlight = {
        use_nvim_cmp_as_default = true,
      },

      nerd_font_variant = true,
      accept = { auto_blankets = { enabled = true } },
      trigger = { signature_help = { enabled = true } },

      windows = {
        autocomplete = {
          border = 'single',
          winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None',
          draw = 'reversed',
        },
        documentation = {
          auto_show = true,
          border = 'single',
          winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
        },
        signature_help = {
          border = 'single',
        }
      },
    }
  }
}
