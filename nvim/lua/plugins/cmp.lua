return {
  -- autocomplete and its sources
  {
    "hrsh7th/nvim-cmp",
    url = "https://github.com/iguanacucumber/magazine.nvim",
    enabled = false,
    event = { "InsertEnter" },
    version = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      -- 'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- 'lukas-reineke/cmp-rg',
    },
    config = function()
      local cmp = require('cmp')
      local cmp_util = require('util.cmp')
      local types = require("cmp.types")
      -- local defaults = require("cmp.config.default")()

      local priority_map = {
        -- [types.lsp.CompletionItemKind.EnumMember] = 1,
        -- [types.lsp.CompletionItemKind.Variable] = 2,
        [types.lsp.CompletionItemKind.Text] = 100, -- to the bottom
      }

      local kind = function(entry1, entry2)
        local kind1 = entry1:get_kind()
        local kind2 = entry2:get_kind()
        kind1 = priority_map[kind1] or kind1
        kind2 = priority_map[kind2] or kind2
        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Snippet then
            return true
          end
          if kind2 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
          local diff = kind1 - kind2
          if diff < 0 then
            return true
          elseif diff > 0 then
            return false
          end
        end
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
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
        sorting = {
          priority_weight = 100,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- cmp-under
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,
            kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
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
          -- {
          --   name = 'rg',
          --   keyword_length = 3
          -- },
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
        performance = {
          max_view_entries = 100,
        },
      })

      vim.keymap.set("i", vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), function()
        cmp.complete()
      end)

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources(
      --     {
      --       { name = 'cmdline' }
      --     }
      --   )
      -- })
    end
  },

  {
    'saghen/blink.cmp',
    enabled = true,
    -- lazy = false,
    event = "InsertEnter",
    version = 'v0.*',
    -- opts_extend = {
    --   "sources.completion.enabled_providers",
    --   "sources.compat",
    --   "sources.default",
    -- },
    dependencies = {
      {
        "saghen/blink.compat",
        opts = {},
        version = '*'
      },
    },
    opts = {
      keymap = {
        preset = 'enter'
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        kind_icons = vim.tbl_extend("keep", {
          Color = "󱓻",
        }, require('config.icons').kinds),
      },

      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            columns = { {'kind_icon'}, {'label'}, {'source_name'} },
            components = {
              source_name = {
                text = function(ctx) return ctx.item.detail or ctx.source_name end,
              }
            }
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        -- list = {
        --   selection = "auto_insert"
        -- },
        ghost_text = {
          enabled = false,
        },
      },

      -- experimental signature help support
      signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },
      -- windows = {
      --   autocomplete = {
      --     border = 'single',
      --     winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None',
      --     -- selection = 'auto_insert',
      --     -- draw = require('util.cmp').draw,
      --   },
      --   documentation = {
      --     auto_show = true,
      --     border = 'single',
      --     winhighlight = 'Normal:CmpPmenu,CursorLine:Pmenu,Search:None'
      --   },
      --   signature_help = {
      --     border = 'single',
      --   }
      -- },
    }
  }
}
