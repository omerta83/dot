return {
  --- Copilot
  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       hide_during_completion = false,
  --       keymap = {
  --         accept = '<M-CR>',
  --         accept_word = '<M-w>',
  --         accept_line = '<M-e>',
  --         next = '<M-]>',
  --         prev = '<M-[>',
  --         dismiss = '<C-e>',
  --       }
  --     },
  --     panel = {
  --       enabled = false,
  --     }
  --   },
  -- },

  -- {
  --   'olimorris/codecompanion.nvim',
  --   cmd = { 'CodeCompanion', 'CodeCompanionActions' },
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   keys = {
  --     { '<leader>At', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
  --     { '<leader>Aa', '<cmd>CodeCompanionChat Add<cr>',    desc = 'Add to CodeCompanion chat', mode = 'x' },
  --   },
  --   opts = function()
  --     local config = require('codecompanion.config').config
  --
  --     local diff_opts = config.display.diff.opts
  --     table.insert(diff_opts, 'context:99') -- Setting the context to a very large number disables folding.
  --
  --     return {
  --       strategies = {
  --         inline = {
  --           keymaps = {
  --             accept_change = {
  --               modes = { n = '<leader>Ay' },
  --               description = 'Accept the suggested change',
  --             },
  --             reject_change = {
  --               modes = { n = '<leader>An' },
  --               description = 'Reject the suggested change',
  --             },
  --           },
  --         },
  --       },
  --       display = {
  --         diff = { opts = diff_opts },
  --       },
  --     }
  --   end,
  -- },

  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if require("sidekick").nes_jump_or_apply() then
            return -- jumped or applied
          end

          -- if you are using Neovim's native inline completions
          if vim.lsp.inline_completion.get() then
            return
          end

          -- fall back to normal tab
          return "<tab>"
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<C-e>",
        function()
          require("sidekick.cli").focus()
        end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ focus = true })
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "v" },
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select({ filter = { installed = true } }) end,
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").select_prompt()
        end,
        desc = "Sidekick Ask Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Claude Toggle",
        mode = { "n", "v" },
      },
    },
  },
}
