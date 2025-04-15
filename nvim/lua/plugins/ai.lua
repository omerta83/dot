return {
  --- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
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
      model = 'claude-3.5-sonnet',
    },
    -- See Commands section for default commands if you want to lazy load on them
    cmd = { "CopilotChatModels" },
    keys = {
      { "<leader>zc", ":CopilotChat<CR>",         desc = "Chat with Copilot" },
      { "<leader>ze", ":CopilotChatExplain<CR>",  mode = "v",                desc = "Explain Code" },
      { "<leader>zr", ":CopilotChatReview<CR>",   mode = "v",                desc = "Review Code" },
      { "<leader>zf", ":CopilotChatFix<CR>",      mode = "v",                desc = "Fix Code Issues" },
      { "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v",                desc = "Optimize Code" },
      { "<leader>zd", ":CopilotChatDocs<CR>",     mode = "v",                desc = "Generate Docs" },
      { "<leader>zt", ":CopilotChatTests<CR>",    mode = "v",                desc = "Generate Tests" },
      { "<leader>zm", ":CopilotChatCommit<CR>",   mode = "n",                desc = "Generate Commit Message" },
      { "<leader>zs", ":CopilotChatCommit<CR>",   mode = "v",                desc = "Generate Commit Message for Selection" },
    }
  },

  {
    "joshuavial/aider.nvim",
    cmd = { "AiderOpen", "AiderAddModifiedFiles" },
    keys = {
      {
        '<leader>Ao',
        ':AiderOpen<CR>i',
        desc = "Open Aider",
      },
      {
        '<leader>Am',
        ':AiderAddModifiedFiles<CR>',
        desc = "Add all git-modified files to the Aider chat",
      }
    },
    opts = {
      auto_manage_context = false, -- automatically manage buffer context
      default_bindings = false,   -- use default <leader>A keybindings
    },
  }
}
