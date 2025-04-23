return {
  --- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
    opts = {
      suggestion = {
        enabled = false, -- use blink instead
        auto_trigger = false,
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
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },                   -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      model = 'claude-3.7-sonnet',
    },
    -- See Commands section for default commands if you want to lazy load on them
    cmd = { "CopilotChatModels" },
    keys = {
      { "<leader>Ac", ":CopilotChat<CR>",         desc = "Chat with Copilot" },
      { "<leader>Ae", ":CopilotChatExplain<CR>",  mode = "v",                desc = "Explain Code" },
      { "<leader>Ar", ":CopilotChatReview<CR>",   mode = "v",                desc = "Review Code" },
      { "<leader>Af", ":CopilotChatFix<CR>",      mode = "v",                desc = "Fix Code Issues" },
      { "<leader>Ao", ":CopilotChatOptimize<CR>", mode = "v",                desc = "Optimize Code" },
      { "<leader>Ad", ":CopilotChatDocs<CR>",     mode = "v",                desc = "Generate Docs" },
      { "<leader>At", ":CopilotChatTests<CR>",    mode = "v",                desc = "Generate Tests" },
      { "<leader>Ag", ":CopilotChatCommit<CR>",   mode = "n",                desc = "Generate Commit Message" },
      { "<leader>As", ":CopilotChatCommit<CR>",   mode = "v",                desc = "Generate Commit Message for Selection" },
    }
  },

  -- Install with `pnpm install -g @github/copilot-language-server`
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "VeryLazy",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
      vim.keymap.set("n", "<tab>", function()
        require("copilot-lsp.nes").apply_pending_nes()
      end)
    end,
  },
}
