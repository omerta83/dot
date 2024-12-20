return {
  {
    "OXY2DEV/markview.nvim",
    -- lazy = false, -- Recommended
    ft = { "markdown", "quarto", "rmd" }, -- If you decide to lazy-load anyway
    opts = {}
  },

  -- {
  --   'jmbuhr/otter.nvim',
  --   ft = { "markdown", "quarto", "rmd" }, -- If you decide to lazy-load anyway
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   keys = {
  --     {
  --       '<leader>co',
  --       function () require('otter').activate() end,
  --       desc = '[LSP] Activate otter for current buffer',
  --     },
  --   },
  --   opts = {},
  -- },
}
