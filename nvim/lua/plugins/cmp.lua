return {
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
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
    "luckasRanarison/tailwind-tools.nvim",
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        symbol = "󱏿", -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = "#38BDF8",
        },
      },
      custom_filetypes = {}
    }
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      'hrsh7th/cmp-path',
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
          ['<C-c>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            local is_copilot, copilot_suggestion = pcall(require, "copilot.suggestion")
            if is_copilot and copilot_suggestion.is_visible() then
              require("copilot.suggestion").accept()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          -- Copilot Source
          { name = 'nvim_lsp', group_index = 1 },
          -- { name = "copilot",  group_index = 2 },
          { name = "luasnip",  group_index = 2 },
          { name = 'path',     group_index = 2 },
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
        -- window = {
        --   documentation = cmp.config.window.bordered({
        --     winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
        --   }),
        --   completion = cmp.config.window.bordered({
        --     winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
        --   }),
        -- },
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
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },
}
