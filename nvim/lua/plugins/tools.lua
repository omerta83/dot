return {
  {
    'brenoprata10/nvim-highlight-colors',
    event = "BufReadPost",
    opts = {
      render = 'background',
      virtual_symbol = '󱓻',
      enabled_named_colors = true,
      enable_tailwind = true,
    }
  },


  -- {
  --   "andymass/vim-matchup",
  --   event = "BufReadPost",
  --   config = function()
  --     vim.g.matchup_matchparen_deferred = 1
  --     vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
  --     -- vim.g.matchup_matchpref = { html = { nolists = 1 } }
  --   end,
  -- },

  {
    "Wansmer/treesj",
    keys = {
      { "<Leader>J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  -- formatters
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'biome' },
        typescript = { 'biome' },
        ["javascript.jsx"] = { "biome", "rustywind" },
        javascriptreact = { "biome", "rustywind" },
        ["typescript.tsx"] = { 'biome', 'rustywind' },
        typescriptreact = { 'biome', 'rustywind' },
        vue = { 'prettier', 'rustywind' },
        lua = { 'stylua' },
        python = { 'ruff' },
        go = { 'goimports', 'gofmt' },
      }
    },
  },
}
