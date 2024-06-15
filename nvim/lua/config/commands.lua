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

    vim.keymap.set("n", "<Leader>to", "<cmd>PyrightOrganizeImports<CR>", {
      buffer = event.buf,
      silent = true,
      noremap = true,
    })
  end,
})

-- keymaps for typescript development
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('omerta/typescript_tools', { clear = true }),
  desc = "Keymaps for typescript tools",
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
      "<leader>to",
      "<cmd>TSToolsOrganizeImports<CR>",
      { buffer = bufnr, desc = "[Typescript Tools] Organize Imports" }
    )
    vim.keymap.set(
      "n",
      "<leader>cr",
      "<cmd>TSToolsRenameFile<CR>",
      { desc = "[Typescript Tools] Rename File", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>td",
      "<cmd>TSToolsGoToSourceDefinition<CR>",
      { desc = "[Typescript Tools] Go To Source Definition", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>ti",
      "<cmd>TSToolsAddMissingImports<CR>",
      { desc = "[Typescript Tools] Add Missing Imports", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>tu",
      "<cmd>TSToolsRemoveUnusedImports<CR>",
      { desc = "[Typescript Tools] Remove Unused Imports", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>tr",
      "<cmd>TSToolsRenameFile<CR>",
      { desc = "[Typescript Tools] Rename File", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "<leader>tf",
      "<cmd>TSToolsFixAll<CR>",
      { desc = "[Typescript Tools] Fix All Errors", buffer = bufnr }
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
  },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf })
  end,
})

-- Close fugitive with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitiveblame", "fugitive" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', 'gq', { silent = true })
  end
})
