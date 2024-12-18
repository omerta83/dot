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
      win = {
        border = "single",
      },
      keys = {
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
      },
      replace = {
        key = {
          { "<CR>", "⏎" },
          { "<BS>", "⌫" },
          { "<Space>", "󱁐" },
          { "<Tab>", "󰌒" },
          { "<Esc>", "⎋" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>b",  group = "+buffer" },
        { "<leader>c",  group = "+code" },
        { "<leader>d",  group = "+debug" },
        { "<leader>f",  group = "+find" },
        { "<leader>g",  group = "+git" },
        { "<leader>gd", group = "+diffview" },
        { "<leader>gs", group = "+gitsigns" },
        { "<leader>o",  group = "+overseer" },
        { "<leader>r",  group = "+refactoring" },
        { "<leader>s",  group = "+flash" },
        { "<leader>t",  group = "+term" },
        { "<leader>w",  group = "+window" },
        { "<leader>x",  group = "+loclist/quickfix" },
      })
    end,
  },
}
