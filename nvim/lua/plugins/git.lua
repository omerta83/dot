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
        utils.map({ "n", "x", "o" }, "]h", gs.next_hunk, { desc = "Next Hunk" })
        utils.map({ "n", "x", "o" }, "[h", gs.prev_hunk, { desc = "Prev Hunk" })
        utils.map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
        utils.map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
        utils.map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
        utils.map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        utils.map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
        utils.map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        utils.map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        utils.map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
        utils.map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
        utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    config = true,
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>",  desc = "DiffView Open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView Current File History" },
    },
  },
}
