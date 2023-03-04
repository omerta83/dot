return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged"
    },
    -- keys = {
    --   {
    --     "<tab>",
    --     function()
    --       return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --     end,
    --     expr = true, silent = true, mode = "i",
    --   },
    --   { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    --   { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    -- },
  },
  {
    "windwp/nvim-autopairs",
    -- event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-buffer', -- nvim-cmp source for buffer words
      'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'saadparwaiz1/cmp_luasnip',
      'windwp/nvim-autopairs'
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require 'luasnip'

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
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-e>'] = cmp.mapping.close(),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
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
          { name = 'luasnip' },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', require('config.icons').kinds[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        },
        experimental = {
          ghost_text = true
        },
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect"
        }
      })

      -- vim.cmd [[
      --   set completeopt=menu,menuone,noselect
      --   highlight! default link CmpItemKind CmpItemMenuDefault
      -- ]]
    end
  }
}
