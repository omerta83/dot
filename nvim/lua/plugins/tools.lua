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

  -- linter
  -- Copied from https://github.com/stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/lint.lua
  {
    "mfussenegger/nvim-lint",
    ft = {
      "javascript",
      "javascript.jsx",
      "javascriptreact",
      "lua",
      "python",
      "rst",
      "typescript",
      "typescript.tsx",
      "typescriptreact",
      "vue",
    },
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        ["javascript.jsx"] = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        ["typescript.tsx"] = { "eslint" },
        typescriptreact = { "eslint" },
        vue = { "eslint" },
        lua = { "luacheck" },
        python = { "ruff" },
        rst = { "rstlint" },
      },
      linters = {},
    },
    config = function(_, opts)
      local uv = vim.uv or vim.loop
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft
      for k, v in pairs(opts.linters) do
        lint.linters[k] = v
      end
      local timer = assert(uv.new_timer())
      local DEBOUNCE_MS = 500
      local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = aug,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          timer:stop()
          timer:start(
            DEBOUNCE_MS,
            0,
            vim.schedule_wrap(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                  lint.try_lint(nil, { ignore_errors = true })
                end)
              end
            end)
          )
        end,
      })
      lint.try_lint(nil, { ignore_errors = true })
    end,
  },
}
