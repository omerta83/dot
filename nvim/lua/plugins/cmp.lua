return {
  {
    'dcampos/nvim-snippy',
    -- dependencies = {
    -- 'rafamadriz/friendly-snippets',
    -- },
    keys = {
      { '<Tab>', mode = { 'i', 'x' } },
      'g<Tab>',
    },
    ft = 'snippets',
    cmd = { 'SnippyEdit', 'SnippyReload' },
    -- event = "VeryLazy",
    config = true
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      'hrsh7th/cmp-path',
      'dcampos/cmp-snippy',
      {
        'windwp/nvim-autopairs',
        opts = {
          disable_filetype = { "TelescopePrompt", "vim" }
        },
        config = function(_, opts)
          local Rule = require('nvim-autopairs.rule')
          local npairs = require('nvim-autopairs')
          npairs.setup(opts)
          npairs.add_rules({
            Rule("|", "|", { "rust" })
          })
        end
      }
    },
    config = function()
      local cmp = require('cmp')
      local snippy = require('snippy')

      -- If you want insert `(` after select function or method item
      local autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        autopairs.on_confirm_done()
      )

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            snippy.expand_snippet(args.body)
          end,
        },
        sorting = {
          -- Extract from TJ's config: https://github.com/tjdevries/config_manager/blob/78608334a7803a0de1a08a9a4bd1b03ad2a5eb11/xdg_config/nvim/after/plugin/completion.lua#L129
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
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

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-x><C-o>'] = cmp.mapping.complete(),
          -- ['<C-e>'] = cmp.mapping.close(),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
              snippy.previous(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = 'snippy' },
        }),
        formatting = {
          format = function(entry, vim_item)
            local width = 2
            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format(
              '%s %s',
              vim_item.kind ~= string.rep('X', width) and require('config.icons').kinds[vim_item.kind] or '',
              vim_item.kind ~= string.rep('X', width) and vim_item.kind or string.rep(' ', width)
            ) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              snippy = "[Snippy]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end,
          -- format = require("tailwindcss-colorizer-cmp").formatter
        },
        experimental = {
          -- ghost_text = {
          --   enabled = true
          -- }
        },
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect"
        }
      })
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = 'path' }
      --   }, {
      --     { name = 'cmdline' }
      --   })
      -- })
    end
  },
}
