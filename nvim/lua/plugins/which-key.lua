return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      preset = 'helix',
      -- delay = 400,
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
        -- { "<leader>b",  group = "buffer" },
        { "<leader>c",  group = "code" },
        -- { "<leader>d",  group = "debug" },
        { "<leader>f",  group = "find" },
        { "<leader>g",  group = "git" },
        { "<leader>gs", group = "gitsigns" },
        -- { "<leader>gd", group = "diffview" },
        { "<leader>o",  group = "ops" },
        { "<leader>cx", group = "refactor" },
        { "<leader>t",  group = "terminal" },
        { "<leader>w",  group = "window" },
        { "<leader>x",  group = "diagnostics/quickfix" },
      })
    end,
  },
}
