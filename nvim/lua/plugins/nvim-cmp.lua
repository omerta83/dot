return {
  -- autocomplete and its sources
  {
    "hrsh7th/nvim-cmp",
    url = "https://github.com/iguanacucumber/magazine.nvim",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    version = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require('cmp')
      local cmp_util = require('util.cmp')
      local defaults = require("cmp.config.default")()

      cmp.setup({
        snippet = {
          expand = function(args)
            -- require("luasnip").lsp_expand(args.body)
            vim.snippet.expand(args.body)
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
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- elseif luasnip.expand_or_locally_jumpable() then
              --   luasnip.expand_or_jump()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
              -- elseif luasnip.expand_or_locally_jumpable(-1) then
              --   luasnip.jump(-1)
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
            },
            entry_filter = cmp_util.lsp_entry_filter,
          },
          { name = 'nvim_lsp_signature_help' },
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
          format = cmp_util.format,
        },
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
          }),
        },
      })

      vim.keymap.set("i", vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), function()
        cmp.complete()
      end)

      -- https://github.com/vuejs/language-tools/discussions/4495
      cmp.event:on('menu_closed', cmp_util.clear_cache)

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'cmdline' }
          }
        )
      })
    end
  },

  {
    'saghen/blink.cmp',
    enabled = false,
    lazy = false,
    -- dependencies = 'rafamadriz/friendly-snippets',
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
