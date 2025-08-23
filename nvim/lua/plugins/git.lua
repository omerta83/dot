local icons = require('config.icons')

return {
  {
    'lewis6991/gitsigns.nvim',
    -- event = { "BufReadPre", "BufNewFile" },
    event = "VeryLazy",
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
        utils.map("n", "<leader>gsb", "<cmd>Gitsigns toggle_current_line_blame<CR>",
          { desc = "Gitsigns toggle [b]lame line" })
        utils.map("n", "<leader>gsd", gs.diffthis, { desc = "Gitsigns [d]iff this" })
        utils.map("n", "<leader>gsD", function() gs.diffthis("~") end, { desc = "Gitsigns [D]iff this ~" })
        utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    -- event = "VeryLazy",
    cmd = "Git",
    keys = {
      { "<leader>gf", "<cmd>Git<CR>",    desc = "De[f]ault git status output in split view" },
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

  -- Copied from https://github.com/MariaSolOs/dotfiles/blob/8cdc092c0c340f669bef33a932f235dcde3c2019/.config/nvim/lua/plugins/diffview.lua
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>gdh', '<cmd>DiffviewFileHistory<cr>', desc = 'File history' },
      { '<leader>gdo', '<cmd>DiffviewOpen<cr>',        desc = 'Diff view' },
    },
    opts = function()
      local actions = require 'diffview.actions'

      require('diffview.ui.panel').Panel.default_config_float.border = 'rounded'

      return {
        default_args = { DiffviewFileHistory = { '%' } },
        icons = {
          folder_closed = icons.kinds.Folder,
          folder_open = '󰝰',
        },
        signs = {
          fold_closed = icons.arrows.right,
          fold_open = icons.arrows.down,
          done = '',
        },
        hooks = {
          diff_buf_read = function(bufnr)
            -- Register the leader group with miniclue.
            vim.b[bufnr].miniclue_config = {
              clues = {
                { mode = 'n', keys = '<leader>G', desc = '+diffview' },
              },
            }
          end,
        },
        -- stylua: ignore start
        keymaps = {
          -- Easier to just configure what I need.
          disable_defaults = true,
          view = {
            { 'n', '<tab>',      actions.select_next_entry,             { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>',    actions.select_prev_entry,             { desc = 'Open the diff for the previous file' } },
            { 'n', '[F',         actions.select_first_entry,            { desc = 'Open the diff for the first file' } },
            { 'n', ']F',         actions.select_last_entry,             { desc = 'Open the diff for the last file' } },
            { 'n', '[x',         actions.prev_conflict,                 { desc = 'Merge-tool: jump to the previous conflict' } },
            { 'n', ']x',         actions.next_conflict,                 { desc = 'Merge-tool: jump to the next conflict' } },
            { 'n', 'gf',         actions.goto_file_tab,                 { desc = 'Open the file in a new tabpage' } },
            { 'n', '<leader>Go', actions.conflict_choose('ours'),       { desc = 'Choose the OURS version of a conflict' } },
            { 'n', '<leader>Gt', actions.conflict_choose('theirs'),     { desc = 'Choose the THEIRS version of a conflict' } },
            { 'n', '<leader>Gb', actions.conflict_choose('base'),       { desc = 'Choose the BASE version of a conflict' } },
            { 'n', '<leader>Ga', actions.conflict_choose('all'),        { desc = 'Choose all the versions of a conflict' } },
            { 'n', '<leader>Gd', actions.conflict_choose('none'),       { desc = 'Delete the conflict region' } },
            { 'n', '<leader>GO', actions.conflict_choose_all('ours'),   { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>GT', actions.conflict_choose_all('theirs'), { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>GB', actions.conflict_choose_all('base'),   { desc = 'Choose the BASE version of a conflict for the whole file' } },
            unpack(actions.compat.fold_cmds),
          },
          diff2 = {
            { 'n', '?', actions.help { 'view', 'diff2' }, { desc = 'Open the help panel' } },
          },
          diff3 = {
            { 'n', '?', actions.help { 'view', 'diff3' }, { desc = 'Open the help panel' } },
          },
          file_panel = {
            { 'n', 'j',          actions.next_entry,                    { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k',          actions.prev_entry,                    { desc = 'Bring the cursor to the previous file entry' } },
            { 'n', '<cr>',       actions.select_entry,                  { desc = 'Open the diff for the selected entry' } },
            { 'n', 's',          actions.toggle_stage_entry,            { desc = 'Stage / unstage the selected entry' } },
            { 'n', 'S',          actions.stage_all,                     { desc = 'Stage all entries' } },
            { 'n', 'U',          actions.unstage_all,                   { desc = 'Unstage all entries' } },
            { 'n', 'X',          actions.restore_entry,                 { desc = 'Restore entry to the state on the left side' } },
            { 'n', 'L',          actions.open_commit_log,               { desc = 'Open the commit log panel' } },
            { 'n', 'gf',         actions.goto_file_tab,                 { desc = 'Open the file in a new tabpage' } },
            { 'n', 'za',         actions.toggle_fold,                   { desc = 'Toggle fold' } },
            { 'n', 'zR',         actions.open_all_folds,                { desc = 'Expand all folds' } },
            { 'n', 'zM',         actions.close_all_folds,               { desc = 'Collapse all folds' } },
            { 'n', '<c-b>',      actions.scroll_view(-0.25),            { desc = 'Scroll the view up' } },
            { 'n', '<c-f>',      actions.scroll_view(0.25),             { desc = 'Scroll the view down' } },
            { 'n', '<tab>',      actions.select_next_entry,             { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>',    actions.select_prev_entry,             { desc = 'Open the diff for the previous file' } },
            { 'n', '[F',         actions.select_first_entry,            { desc = 'Open the diff for the first file' } },
            { 'n', ']F',         actions.select_last_entry,             { desc = 'Open the diff for the last file' } },
            { 'n', 'i',          actions.listing_style,                 { desc = 'Toggle between "list" and "tree" views' } },
            { 'n', '[x',         actions.prev_conflict,                 { desc = 'Go to the previous conflict' } },
            { 'n', ']x',         actions.next_conflict,                 { desc = 'Go to the next conflict' } },
            { 'n', '?',          actions.help('file_panel'),            { desc = 'Open the help panel' } },
            { 'n', '<leader>GO', actions.conflict_choose_all('ours'),   { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>GT', actions.conflict_choose_all('theirs'), { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>GB', actions.conflict_choose_all('base'),   { desc = 'Choose the BASE version of a conflict for the whole file' } },
            { 'n', '<leader>GA', actions.conflict_choose_all('all'),    { desc = 'Choose all the versions of a conflict for the whole file' } },
            { 'n', '<leader>GD', actions.conflict_choose_all('none'),   { desc = 'Delete the conflict region for the whole file' } },
          },
          file_history_panel = {
            { 'n', '!',         actions.options,                    { desc = 'Open the option panel' } },
            { 'n', '<leader>d', actions.open_in_diffview,           { desc = 'Open the entry under the cursor in a diffview' } },
            { 'n', 'y',         actions.copy_hash,                  { desc = 'Copy the commit hash of the entry under the cursor' } },
            { 'n', 'L',         actions.open_commit_log,            { desc = 'Show commit details' } },
            { 'n', 'X',         actions.restore_entry,              { desc = 'Restore file to the state from the selected entry' } },
            { 'n', 'za',        actions.toggle_fold,                { desc = 'Toggle fold' } },
            { 'n', 'zR',        actions.open_all_folds,             { desc = 'Expand all folds' } },
            { 'n', 'zM',        actions.close_all_folds,            { desc = 'Collapse all folds' } },
            { 'n', 'j',         actions.next_entry,                 { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k',         actions.prev_entry,                 { desc = 'Bring the cursor to the previous file entry' } },
            { 'n', '<cr>',      actions.select_entry,               { desc = 'Open the diff for the selected entry' } },
            { 'n', '<c-b>',     actions.scroll_view(-0.25),         { desc = 'Scroll the view up' } },
            { 'n', '<c-f>',     actions.scroll_view(0.25),          { desc = 'Scroll the view down' } },
            { 'n', '<tab>',     actions.select_next_entry,          { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>',   actions.select_prev_entry,          { desc = 'Open the diff for the previous file' } },
            { 'n', '[F',        actions.select_first_entry,         { desc = 'Open the diff for the first file' } },
            { 'n', ']F',        actions.select_last_entry,          { desc = 'Open the diff for the last file' } },
            { 'n', 'gf',        actions.goto_file_tab,              { desc = 'Open the file in a new tabpage' } },
            { 'n', '?',         actions.help('file_history_panel'), { desc = 'Open the help panel' } },
          },
          option_panel = {
            { 'n', '<tab>', actions.select_entry,         { desc = 'Change the current option' } },
            { 'n', 'q',     actions.close,                { desc = 'Close the panel' } },
            { 'n', '?',     actions.help('option_panel'), { desc = 'Open the help panel' } },
          },
          help_panel = {
            { 'n', 'q', actions.close, { desc = 'Close help menu' } },
          },
        },
        -- stylua: ignore end
      }
    end,
  },
}
