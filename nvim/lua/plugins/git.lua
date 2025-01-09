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
        utils.map({ "n", "x", "o" }, "]h", gs.next_hunk, { desc = "Next [h]unk" })
        utils.map({ "n", "x", "o" }, "[h", gs.prev_hunk, { desc = "Prev [h]unk" })
        utils.map({ "n", "v" }, "<leader>gss", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns [s]tage hunk" })
        utils.map({ "n", "v" }, "<leader>gsr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns [r]eset hunk" })
        utils.map("n", "<leader>gsS", gs.stage_buffer, { desc = "Gitsigns [S]tage buffer" })
        utils.map("n", "<leader>gsu", gs.undo_stage_hunk, { desc = "Gitsigns [u]ndo stage hunk" })
        utils.map("n", "<leader>gsR", gs.reset_buffer, { desc = "Gitsigns [R]eset buffer" })
        utils.map("n", "<leader>gsp", gs.preview_hunk, { desc = "Gitsigns [p]review hunk" })
        -- utils.map("n", "<leader>gsb", function() gs.blame_line({ full = true }) end, { desc = "[Gitsigns] Blame Line" })
        utils.map("n", "<leader>gsb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns toggle [b]lame line" })
        utils.map("n", "<leader>gsd", gs.diffthis, { desc = "Gitsigns [d]iff this" })
        utils.map("n", "<leader>gsD", function() gs.diffthis("~") end, { desc = "Gitsigns [D]iff this ~" })
        utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gf", "<cmd>Git<CR>", desc = "De[f]ault git status output in split view" },
      { "<leader>gi", "<cmd>Gedit:<CR>", desc = "G[i]t status" },
    },
    config = function()
      -- vim.keymap.set("n", "<leader>gf", vim.cmd.Git)

      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("omerta/fugitive", {}),
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
          end, opts)

          -- rebase always
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ 'pull', '--rebase' })
          end, opts)

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set("n", "<leader>gp", ":Git push -u origin ", opts);
        end,
      })


      vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>")
      vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>")
    end
  },

  -- {
  --   "sindrets/diffview.nvim",
  --   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  --   keys = {
  --     { "<leader>gdo", "<cmd>DiffviewOpen<cr>",          desc = "[DiffView] Open" },
  --     { "<leader>gdc", "<cmd>DiffviewClose<cr>",         desc = "[DiffView] Close" },
  --     { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "[DiffView] Show Current File History" },
  --   },
  --   config = function()
  --     local actions = require("diffview.actions")
  --     require('diffview').setup({
  --       enhanced_diff_hl = true,
  --       view = {
  --         default = {
  --           disable_diagnostics = true,
  --         },
  --         merge_tool = {
  --           layout = "diff3_mixed",
  --         }
  --       },
  --       file_history_panel = {
  --         win_config = {
  --           type = 'split',
  --           position = 'right',
  --           width = 50
  --         }
  --       },
  --       -- Copied from https://github.com/gennaro-tedesco/dotfiles/blob/b72d44767061d61ac2a06c85d85949ad7ee19234/nvim/lua/plugins/diffview.lua?plain=1#L31-L123
  --       keymaps = {
  --         disable_defaults = true,
  --         view = {
  --           { "n", "<C-f>",       actions.toggle_files,                  { desc = "Toggle the file panel" } },
  --           { "n", "gf",          actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
  --           { "n", "<leader>gco", actions.conflict_choose_all("ours"),   { desc = "Choose conflict --ours" } },
  --           { "n", "<leader>gct", actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
  --           { "n", "<leader>gcb", actions.conflict_choose_all("base"),   { desc = "Choose conflict --base" } },
  --           ["gq"] = function()
  --             if vim.fn.tabpagenr("$") > 1 then
  --               vim.cmd.DiffviewClose()
  --             else
  --               vim.cmd.quitall()
  --             end
  --           end,
  --         },
  --         file_panel = {
  --           { "n", "j",       actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
  --           { "n", "<down>",  actions.select_next_entry,             { desc = "Select the next file entry" } },
  --           { "n", "k",       actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
  --           { "n", "<up>",    actions.select_prev_entry,             { desc = "Select the previous file entry" } },
  --           { "n", "<cr>",    actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
  --           { "n", "<C-f>",   actions.toggle_files,                  { desc = "Toggle the file panel" } },
  --           { "n", "s",       actions.toggle_stage_entry,            { desc = "Stage/unstage the selected entry" } },
  --           { "n", "S",       actions.stage_all,                     { desc = "Stage all entries" } },
  --           { "n", "U",       actions.unstage_all,                   { desc = "Unstage all entries" } },
  --           { "n", "c-",      actions.prev_conflict,                 { desc = "Go to prev conflict" } },
  --           { "n", "c+",      actions.next_conflict,                 { desc = "Go to next conflict" } },
  --           { "n", "gf",      actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
  --           { "n", "co",      actions.conflict_choose_all("ours"),   { desc = "Choose conflict --ours" } },
  --           { "n", "ct",      actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
  --           { "n", "cb",      actions.conflict_choose_all("base"),   { desc = "Choose conflict --base" } },
  --           { "n", "<Right>", actions.open_fold,                     { desc = "Expand fold" } },
  --           { "n", "<Left>",  actions.close_fold,                    { desc = "Collapse fold" } },
  --           { "n", "l",       actions.listing_style,                 { desc = "Toggle between 'list' and 'tree' views" } },
  --           { "n", "L",       actions.open_commit_log,               { desc = "Open the commit log panel" } },
  --           { "n", "g?",      actions.help("file_panel"),            { desc = "Open the help panel" } },
  --           ["gq"] = function()
  --             if vim.fn.tabpagenr("$") > 1 then
  --               vim.cmd.DiffviewClose()
  --             else
  --               vim.cmd.quitall()
  --             end
  --           end,
  --           {
  --             "n",
  --             "cc",
  --             function()
  --               vim.ui.input({ prompt = "Commit message: " }, function(msg)
  --                 if not msg then
  --                   return
  --                 end
  --                 local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
  --                 vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit", render = "simple" })
  --               end)
  --             end,
  --           },
  --           {
  --             "n",
  --             "cx",
  --             function()
  --               local results = vim.system({ "git", "commit", "--amend", "--no-edit" }, { text = true }):wait()
  --               vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit amend", render = "simple" })
  --             end,
  --           },
  --         },
  --         diff2 = {
  --           { "n", "++", "]c" },
  --           { "n", "--", "[c" },
  --         },
  --         file_history_panel = {
  --           { "n", "j",      actions.next_entry,                 { desc = "Bring the cursor to the next log entry" } },
  --           { "n", "<down>", actions.select_next_entry,          { desc = "Select the next log entry" } },
  --           { "n", "k",      actions.prev_entry,                 { desc = "Bring the cursor to the previous log entry." } },
  --           { "n", "<up>",   actions.select_prev_entry,          { desc = "Select the previous file entry." } },
  --           { "n", "<cr>",   actions.select_entry,               { desc = "Open the diff for the selected entry." } },
  --           { "n", "gd",     actions.open_in_diffview,           { desc = "Open the entry under the cursor in a diffview" } },
  --           { "n", "y",      actions.copy_hash,                  { desc = "Copy the commit hash of the entry under the cursor" } },
  --           { "n", "L",      actions.open_commit_log,            { desc = "Show commit details" } },
  --           { "n", "gf",     actions.goto_file_edit,             { desc = "Open the file in the previous tabpage" } },
  --           { "n", "g?",     actions.help("file_history_panel"), { desc = "Open the help panel" } },
  --           ["gq"] = function()
  --             if vim.fn.tabpagenr("$") > 1 then
  --               vim.cmd.DiffviewClose()
  --             else
  --               vim.cmd.quitall()
  --             end
  --           end,
  --         },
  --         help_panel = {
  --           { "n", "q", actions.close, { desc = "Close help menu" } },
  --         },
  --       },
  --     })
  --   end
  -- },
}
