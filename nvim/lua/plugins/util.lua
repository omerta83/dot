return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  { "tpope/vim-surround", event = "BufReadPost" },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "BufReadPost" },
}
