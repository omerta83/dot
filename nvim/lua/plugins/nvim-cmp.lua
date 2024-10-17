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
      local defaults = require("cmp.config.default")()

      -- https://github.com/vuejs/language-tools/discussions/4495
      local function is_in_start_tag()
        local ts_utils = require('nvim-treesitter.ts_utils')
        local node = ts_utils.get_node_at_cursor()
        if not node then
          return false
        end
        local node_to_check = { 'start_tag', 'self_closing_tag', 'directive_attribute' }
        return vim.tbl_contains(node_to_check, node:type())
      end

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
            -- select = true
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
            -- integration for Vue props and emits
            -- https://github.com/vuejs/language-tools/discussions/4495
            entry_filter = function(entry, ctx)
              -- Use a buffer-local variable to cache the result of the Treesitter check
              local bufnr = ctx.bufnr
              local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
              if cached_is_in_start_tag == nil then
                vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
              end
              -- If not in start tag, return true
              if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
                return true
              end
              -- Check if the buffer type is 'vue'
              if ctx.filetype ~= 'vue' then
                return true
              end

              local cursor_before_line = ctx.cursor_before_line
              -- For events
              if cursor_before_line:sub(-1) == '@' then
                return entry.completion_item.label:match('^@')
                -- For props also exclude events with `:on-` prefix
              elseif cursor_before_line:sub(-1) == ':' then
                return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
              else
                return true
              end

              -- TODO: filter out emmet_ls items when not in html for vue, react
              -- https://github.com/hrsh7th/nvim-cmp/issues/806#issuecomment-1207815660
            end
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
          format = function(entry, vim_item)
            -- format: [abbr] [kind (icon + name)] [menu (symbol info if available)]
            local color_item = require('nvim-highlight-colors').format(entry, { kind = vim_item.kind })
            local completion_item = entry:get_completion_item()
            -- Kind icons
            local icons = require('config.icons').kinds
            local kind_icon = ''
            local kind_name = vim_item.kind
            if icons[vim_item.kind] then
              kind_icon = icons[vim_item.kind]
            end
            -- formatting for tailwindcss and highlight colors
            if color_item.abbr_hl_group then
              vim_item.kind_hl_group = color_item.abbr_hl_group
              kind_icon = color_item.abbr
              kind_name = color_item.menu
            end
            vim_item.kind = string.format(' %s %s', kind_icon, kind_name)
            -- symbol info if available
            vim_item.menu = completion_item.detail
            return vim_item
          end,
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
      cmp.event:on('menu_closed', function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
      end)

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
