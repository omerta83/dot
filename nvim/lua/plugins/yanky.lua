return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = { timer = 250 },
    ring = { history_length = 20 },
  },
  keys = {
    -- stylua: ignore
    { "<leader>p", "<Cmd>YankyRingHistory<CR>",              desc = "Open Yank History" },
    {
      "y",
      "<Plug>(YankyYank)",
      desc = "Yank text",
      mode = { "n", "x" },
    },
    {
      "p",
      "<Plug>(YankyPutAfter)",
      desc =
      "Put yanked text after cursor",
      mode = { "n", "x" }
    },
    {
      "P",
      "<Plug>(YankyPutBefore)",
      desc =
      "Put yanked text before cursor",
      mode = { "n", "x" }
    },
    -- {
    --   "gp",
    --   "<Plug>(YankyGPutAfter)",
    --   desc =
    --   "Put yanked text after selection",
    --   mode = { "n", "x" }
    -- },
    -- {
    --   "gP",
    --   "<Plug>(YankyGPutBefore)",
    --   desc =
    --   "Put yanked text before selection",
    --   mode = { "n", "x" }
    -- },
    { "[y",        "<Plug>(YankyCycleForward)",              desc = "Cycle forward through yank history" },
    { "]y",        "<Plug>(YankyCycleBackward)",             desc = "Cycle backward through yank history" },
    { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
    { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
    { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
    { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
    { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and indent right" },
    { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and indent left" },
    { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
    { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put before and indent left" },
    { "=p",        "<Plug>(YankyPutAfterFilter)",            desc = "Put after applying a filter" },
    { "=P",        "<Plug>(YankyPutBeforeFilter)",           desc = "Put before applying a filter" },
  },
}
