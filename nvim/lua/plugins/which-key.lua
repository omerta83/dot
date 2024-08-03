return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      plugins = { spelling = false },
      window = {
        border = "single",
      },
      popup_mappings = {
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
      },
      key_labels = {
        ["<CR>"] = "⏎",
        ["<BS>"] = "⌫",
        ["<space>"] = "󱁐",
        ["<Tab>"] = "󰌒",
        ["<Esc>"] = "⎋",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>"] = {
          f = {
            name = "+find"
          },
          b = {
            name = "+buffer"
          },
          c = {
            name = "+code"
          },
          d = {
            name = "+debug"
          },
          g = {
            name = "+git"
          },
          t = {
            name = "+term"
          },
          w = {
            name = "+window"
          },
          x = {
            name = "+loclist/quickfix"
          }
        },
        ["<leader>g"] = {
          d = {
            name = "+diff"
          },
          s = {
            name = "+gitsigns"
          }
        }
      })
    end,
  },
}
