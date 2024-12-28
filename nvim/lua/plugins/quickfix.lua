return {
  -- better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = function()
      return {
        func_map = {
          fzffilter = '<leader>xf',
          -- stoggledown = '<leader>xj',
          -- stoggleup = '<leader>xk',
          -- sclear = '<leader>xc',
        },
        preview = {
          should_preview_cb = function(bufnr)
            local ret = true
            -- disable preview when on Manpage
            if vim.bo[bufnr].filetype == 'man' or vim.bo[bufnr].filetype == 'help' then
              ret = false
            end
            return ret
          end
        }
      }
    end
  },

  -- Prettier quickfix UI
  {
    'stevearc/quicker.nvim',
    -- event = 'VeryLazy',
    -- ft = "qf",
    keys = {
      {
        '<leader>xq',
        function()
          require('quicker').toggle()
        end,
        desc = 'Toggle quickfix',
      },
      {
        '<leader>xl',
        function()
          require('quicker').toggle { loclist = true }
        end,
        desc = 'Toggle loclist list',
      },
      {
        '<leader>xd',
        function()
          local quicker = require 'quicker'

          if quicker.is_open() then
            quicker.close()
          else
            vim.diagnostic.setqflist()
          end
        end,
        desc = 'Toggle diagnostics',
      },
    },
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
  },
}
