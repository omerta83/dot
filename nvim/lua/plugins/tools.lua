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
      formatters_by_ft = {
        javascript = biome_or_other,
        typescript = biome_or_other,
        ["javascript.jsx"] = biome_or_other(true),
        javascriptreact = biome_or_other(true),
        ["typescript.tsx"] = biome_or_other(true),
        typescriptreact = biome_or_other(true),
        vue = biome_or_other(true),
        lua = { 'stylua' },
        python = { 'ruff' },
        go = { 'goimports', 'gofumpt' },
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

  -- Task runner
  -- {
  --   'stevearc/overseer.nvim',
  --   cmd = {
  --     "OverseerOpen",
  --     "OverseerClose",
  --     "OverseerToggle",
  --     "OverseerSaveBundle",
  --     "OverseerLoadBundle",
  --     "OverseerDeleteBundle",
  --     "OverseerRunCmd",
  --     "OverseerRun",
  --     "OverseerInfo",
  --     "OverseerBuild",
  --     "OverseerQuickAction",
  --     "OverseerTaskAction",
  --     "OverseerClearCache",
  --   },
  --   keys = {
  --     { '<leader>oo', '<cmd>OverseerRun<cr>',         desc = '[Overseer] Run task' },
  --     { '<leader>ow', '<cmd>OverseerToggle<cr>',      desc = '[Overseer] Toggle task runner' },
  --     { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "[Overseer] Action recent task" },
  --     { "<leader>oi", "<cmd>OverseerInfo<cr>",        desc = "[Overseer] Info" },
  --     { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "[Overseer] Task builder" },
  --     { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "[Overseer] Task action" },
  --     { "<leader>oc", "<cmd>OverseerClearCache<cr>",  desc = "[Overseer] Clear cache" },
  --     {
  --       '<leader>ol',
  --       function()
  --         local overseer = require 'overseer'
  --
  --         local tasks = overseer.list_tasks { recent_first = true }
  --         if vim.tbl_isempty(tasks) then
  --           vim.notify('No tasks found', vim.log.levels.WARN)
  --         else
  --           overseer.run_action(tasks[1], 'restart')
  --         end
  --       end,
  --       desc = '[Overseer] Restart last task',
  --     },
  --   },
  --   opts = {
  --     dap = false,
  --     task_list = {
  --       default_detail = 2,
  --       direction = 'bottom',
  --       max_width = { 600, 0.7 },
  --       bindings = {
  --         ['<C-b>'] = 'ScrollOutputUp',
  --         ['<C-f>'] = 'ScrollOutputDown',
  --       },
  --     },
  --   },
  -- }
}
