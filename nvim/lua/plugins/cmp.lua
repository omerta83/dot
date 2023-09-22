return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        -- auto_trigger = true,
        -- keymap = {
        --   accept = false
        -- }
      },
      panel = {
        enabled = false
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
          check_ts = true,
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          local Rule = require('nvim-autopairs.rule')
          local npairs = require('nvim-autopairs')
          npairs.setup(opts)
          npairs.add_rules({
            Rule("|", "|", { "rust" })
          })
        end
      },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup({
            event = { "InsertEnter", "LspAttach" },
            fix_pairs = true,
          })
        end
      },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- If you want insert `(` after select function or method item
      -- local autopairs = require('nvim-autopairs.completion.cmp')
      -- cmp.event:on(
      --   'confirm_done',
      --   autopairs.on_confirm_done()
      -- )

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
        sorting = {
          priority_weight = 2,
          comparators = {
            -- cmp.config.compare.exact,
            require("copilot_cmp.comparators").prioritize,

            -- Extract from TJ's config: https://github.com/tjdevries/config_manager/blob/78608334a7803a0de1a08a9a4bd1b03ad2a5eb11/xdg_config/nvim/after/plugin/completion.lua#L129
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
        -- sorting = defaults.sorting,
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
          -- Copilot Source
          { name = "copilot",  group_index = 2 },
          { name = 'nvim_lsp', group_index = 2 },
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
          { name = "luasnip", group_index = 2 },
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
