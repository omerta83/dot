return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false,
          dismiss = "<C-c>",
        }
      },
      panel = {
        enabled = false,
      }
    }
  },
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
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end
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
          ['<C-x><C-o>'] = cmp.mapping.complete(),
          -- ['<C-e>'] = cmp.mapping.close(),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
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
            local has_tw_colorizer, tw_colorizer = pcall(require, "tailwindcss-colorizer-cmp")
            if has_tw_colorizer then
              vim_item = tw_colorizer.formatter(entry, vim_item)
            end
            -- Kind icons
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
            winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
          }),
          completion = cmp.config.window.bordered({
            winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
          }),
        },
      })
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

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
