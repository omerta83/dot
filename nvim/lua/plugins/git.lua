return {
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '┃' },
        topdelete = { text = '┃' },
        changedelete = { text = '┃' },
      },
      trouble = false,
      -- numhl = true,
      sign_priority = 15, -- higher than diagnostic,todo signs. lower than dapui breakpoint sign
      on_attach = function()
        local gs = package.loaded.gitsigns
        local utils = require("util")

        -- stylua: ignore start
        utils.map({ "n", "x", "o" }, "]h", gs.next_hunk, { desc = "[Gitsigns] Next Hunk" })
        utils.map({ "n", "x", "o" }, "[h", gs.prev_hunk, { desc = "[Gitsigns] Prev Hunk" })
        utils.map({ "n", "v" }, "<leader>gss", ":Gitsigns stage_hunk<CR>", { desc = "[Gitsigns] Stage Hunk" })
        utils.map({ "n", "v" }, "<leader>gsr", ":Gitsigns reset_hunk<CR>", { desc = "[Gitsigns] Reset Hunk" })
        utils.map("n", "<leader>gsS", gs.stage_buffer, { desc = "[Gitsigns] Stage Buffer" })
        utils.map("n", "<leader>gsu", gs.undo_stage_hunk, { desc = "[Gitsigns] Undo Stage Hunk" })
        utils.map("n", "<leader>gsR", gs.reset_buffer, { desc = "[Gitsigns] Reset Buffer" })
        utils.map("n", "<leader>gsp", gs.preview_hunk, { desc = "[Gitsigns] Preview Hunk" })
        utils.map("n", "<leader>gsb", function() gs.blame_line({ full = true }) end, { desc = "[Gitsigns] Blame Line" })
        utils.map("n", "<leader>gsd", gs.diffthis, { desc = "[Gitsigns] Diff This" })
        utils.map("n", "<leader>gsD", function() gs.diffthis("~") end, { desc = "[Gitsigns] Diff This ~" })
        utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[GitSigns] Select Hunk" })
      end,
    },
  },

  -- {
  --   "tpope/vim-fugitive",
  --   cmd = { "G", "Gedit", "Gblame", "Gbrowse", "Gdiff", "Ggrep", "Glog", "Gmove", "Gpull", "Gpush", "Gread", "Gremove", "Grename", "Gstatus", "Gwrite" },
  --   keys = {
  --     { "<leader>gg", "<cmd>G<CR>",      desc = "[Fugitive] Git Status in split view" },
  --     { "<leader>gG", "<cmd>Gedit:<CR>", desc = "[Fugitive] Git Status" },
  --   },
  -- },

  -- {
  --   "sindrets/diffview.nvim",
  --   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  --   config = true,
  --   keys = {
  --     { "<leader>gdo", "<cmd>DiffviewOpen<cr>",          desc = "[DiffView] Open" },
  --     { "<leader>gdc", "<cmd>DiffviewClose<cr>",         desc = "[DiffView] Close" },
  --     { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "[DiffView] Show Current File History" },
  --   },
  -- },
}
