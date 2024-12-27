local biome_or_other = function(includeTailwind)
  local cwd = vim.fn.getcwd()
  local has_biome = vim.fn.filereadable(cwd .. '/biome.json')
  local formatters = has_biome == 1 and { 'biome' } or { 'prettier' }
  if includeTailwind then
    local has_tailwind = vim.fn.filereadable(cwd .. '/tailwind.config.js') or
      vim.fn.filereadable(cwd .. '/tailwind.config.ts')
    if has_tailwind == 1 then
      table.insert(formatters, 'rustywind')
    end
  end
  return formatters
end

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
      formatters = {
        -- fvm dart
        fdart_format = {
          command = "/usr/local/bin/fvm",
          args = { "dart", "format" },
        }
      },
      formatters_by_ft = {
        javascript = biome_or_other,
        javascriptreact = biome_or_other(true),
        typescript = biome_or_other,
        typescriptreact = biome_or_other(true),
        vue = biome_or_other(true),
        lua = { 'stylua' },
        python = { 'ruff' },
        go = { 'goimports', 'gofumpt' },
        dart = { 'fdart_format' },
      }
    },
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    ft = {
      "javascript",
      "javascriptreact",
      "go",
      "python",
      "typescript",
      "typescriptreact",
      "vue",
    },
    opts = {
      linters_by_ft = {
        javascript = { "oxlint" },
        javascriptreact = { "oxlint" },
        typescript = { "oxlint" },
        typescriptreact = { "oxlint" },
        vue = { "oxlint" },
        go = { "golangcilint" },
        python = { "ruff" },
      },
      linters = {},
    },
    config = function(_, opts)
      -- Copied from https://github.com/stevearc/dotfiles/blob/8a34b64a26f5479ac8837b2fb5bdf65464bb0712/.config/nvim/lua/plugins/lint.lua
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
