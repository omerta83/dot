return {
  --- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-CR>',
          accept_word = '<M-w>',
          accept_line = '<M-e>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-e>',
        }
      },
      panel = {
        enabled = false,
      }
    },
  },

  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionActions' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>At', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
      { '<leader>Aa', '<cmd>CodeCompanionChat Add<cr>',    desc = 'Add to CodeCompanion chat', mode = 'x' },
    },
    opts = function()
      local config = require('codecompanion.config').config

      local diff_opts = config.display.diff.opts
      table.insert(diff_opts, 'context:99') -- Setting the context to a very large number disables folding.

      return {
        strategies = {
          inline = {
            keymaps = {
              accept_change = {
                modes = { n = '<leader>Ay' },
                description = 'Accept the suggested change',
              },
              reject_change = {
                modes = { n = '<leader>An' },
                description = 'Reject the suggested change',
              },
            },
          },
        },
        display = {
          diff = { opts = diff_opts },
        },
      }
    end,
  },

  -- Install with `pnpm install -g @github/copilot-language-server`
  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 500
  --     vim.lsp.enable("copilot_ls")
  --     vim.keymap.set("n", "<tab>", function()
  --       -- Try to jump to the start of the suggestion edit.
  --       -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
  --       local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
  --           or (
  --             require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit()
  --           )
  --     end)
  --   end,
  --   opts = {
  --     nes = {
  --       move_count_threshold = 3, -- Clear after 3 cursor movements
  --     }
  --   }
  -- }
}
