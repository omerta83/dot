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
    -- stylua: ignore
    -- keys = {
    --   {
    --     "<tab>",
    --     -- function()
    --     --   return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --     -- end,
    --     -- expr = true, silent = true, 
    --     mode = {"i", "s"},
    --   },
    --   -- { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    --   -- { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    -- },
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
    version = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim's built-in LSP
      'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
      'hrsh7th/cmp-path',
      "saadparwaiz1/cmp_luasnip",
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
      local defaults = require("cmp.config.default")()
      local luasnip = require('luasnip')

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
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
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
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'path', group_index = 5 },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
            group_index = 2
          },
          { name = "luasnip" },
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
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
        },
      })
    end
  },
}
