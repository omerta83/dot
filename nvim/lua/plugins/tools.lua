return {
  {
    'brenoprata10/nvim-highlight-colors',
    event = "VeryLazy",
    -- event = "BufReadPost",
    opts = {
      render = 'background',
      virtual_symbol = '󱓻',
      enabled_named_colors = true,
      enable_tailwind = true,
    }
  },

  {
    "Wansmer/treesj",
    keys = {
      { "<Leader>J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },
}
