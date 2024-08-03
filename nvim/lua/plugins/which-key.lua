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
      wk.add({
        { "<leader>b", group = "+buffer" },
        { "<leader>f", group = "+find" },
        { "<leader>c", group = "+code" },
        { "<leader>g", group = "+git" },
        { "<leader>d", group = "+debug" },
        { "<leader>t", group = "+term" },
        { "<leader>w", group = "+window" },
        { "<leader>x", group = "+loclist/quickfix" },
        { "<leader>s", group = "+flash" },
      })
    end,
  },
}
