--- Go to the last location when opening a buffer
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

--- close with q
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('omerta/close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'git',
    'help',
    -- 'man', -- disable man as it will mess up with q to close outside vim
    'qf',
    'query',
    'gitsigns-blame',
    'scratch',
  },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = event.buf })
  end,
})

--- Close fugitive with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitiveblame", "fugitive" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', 'gq', { silent = true })
  end
})

--- Toggle relative line numbers
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

--- :Todos - Search TODOs with fzf-lua
vim.api.nvim_create_user_command('Todos', function()
  require('fzf-lua').grep { search = 'TODO|FIX|HACK|NOTE|PERF', no_esc = true }
end, { desc = 'Grep TODOs', nargs = 0 })

--- Toggle copilot on blink suggestion
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpCompletionMenuOpen',
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpCompletionMenuClose',
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
