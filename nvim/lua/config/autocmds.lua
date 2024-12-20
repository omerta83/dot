-- python development
-- Extracted from https://github.com/chrisgrieser/nvim-kickstart-python/blob/main/kickstart-python.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python", -- filetype for which to run the autocmd
  group = vim.api.nvim_create_augroup('omerta/python', { clear = true }),
  callback = function(event)
    -- use pep8 standards
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    -- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
    -- if you are a heavy user of folds, consider using `nvim-ufo`
    vim.opt_local.foldmethod = "indent"

    -- automatically capitalize boolean values. Useful if you come from a
    -- different language, and lowercase them out of habit.
    vim.cmd.inoreabbrev("<buffer> true True")
    vim.cmd.inoreabbrev("<buffer> false False")

    -- in the same way, we can fix habits regarding comments or None
    vim.cmd.inoreabbrev("<buffer> -- #")
    vim.cmd.inoreabbrev("<buffer> null None")
    vim.cmd.inoreabbrev("<buffer> none None")
    vim.cmd.inoreabbrev("<buffer> nil None")

    -- vim.keymap.set("n", "<Leader>to", "<cmd>PyrightOrganizeImports<CR>", {
    --   buffer = event.buf,
    --   silent = true,
    --   noremap = true,
    -- })
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('omerta/last_location', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd 'normal! g`"zz'
    end
  end,
})

-- keymaps for typescript development
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('omerta/typescript', { clear = true }),
  desc = "Keymaps for typescript development",
  pattern = {
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "javascript",
    "javascript.jsx",
    "javascriptreact",
  },
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set(
      "n",
      "<leader>co",
      "<cmd>VtsExec organize_imports<CR>",
      { buffer = bufnr, desc = "[Typescript] Organize Imports" }
    )
    vim.keymap.set(
      "n",
      "<leader>cd",
      "<cmd>VtsExec goto_source_definition<CR>",
      { desc = "[Typescript] Go To Source Definition", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>ci",
      "<cmd>VtsExec add_missing_imports<CR>",
      { desc = "[Typescript] Add Missing Imports", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>cu",
      "<cmd>VtsExec remove_unused<CR>",
      { desc = "[Typescript] Remove Unused Imports", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>cn",
      "<cmd>VtsExec rename_file<CR>",
      { desc = "[Typescript] Rename File", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>cs",
      "<cmd>VtsExec file_references<CR>",
      { desc = "[Typescript] File References", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>cF",
      "<cmd>VtsExec fix_all<CR>",
      { desc = "[Typescript] Fix All Errors", buffer = bufnr }
    )
  end
})

-- close with q
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('omerta/close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    -- 'man', -- disable man as it will mess up with q to close outside vim
    'qf',
    'query',
    'gitsigns-blame'
  },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = event.buf })
  end,
})

-- Close fugitive with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitiveblame", "fugitive" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', 'gq', { silent = true })
  end
})

-- Toggle relative line numbers
local line_numbers_group = vim.api.nvim_create_augroup('omerta/toggle_line_numbers', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers on',
  callback = function()
    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers off',
  callback = function(args)
    if vim.wo.nu then
      vim.wo.relativenumber = false
    end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == 'CmdlineEnter' then
      vim.cmd.redraw()
    end
  end,
})

-- :Todos - Search TODOs with fzf-lua
vim.api.nvim_create_user_command('Todos', function()
  require('fzf-lua').grep { search = 'TODO|FIX|HACK|NOTE|PERF', no_esc = true }
end, { desc = 'Grep TODOs', nargs = 0 })
