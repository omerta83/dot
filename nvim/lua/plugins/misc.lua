return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim" },

  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
}
