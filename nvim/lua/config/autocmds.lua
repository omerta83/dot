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
    'log',
    -- 'man', -- disable man as it will mess up with q to close outside vim
    'qf',
    'query',
    'gitsigns-blame',
    'scratch',
    'deck',
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

-- vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
--   desc = 'Redraw buffer when associated file is changed',
--   command = 'checktime',
-- })
-- https://github.com/stevearc/dotfiles/blob/6bc8a8c96af72ab5b0437865542db3ad5d57ba0f/.config/nvim/init.lua#L286C1-L297C3
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
  group = vim.api.nvim_create_augroup("omerta/refresh", {}),
})
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  group = vim.api.nvim_create_augroup("omerta/refresh", {}),
})

--- :Todos - Search TODOs with fzf-lua
vim.api.nvim_create_user_command('Todos', function()
  require('fzf-lua').grep { search = 'TODO|FIX|HACK|NOTE|PERF', no_esc = true }
end, { desc = 'List TODOs', nargs = 0 })

--- Autoclear search highlights
-- vim.api.nvim_create_autocmd('CursorMoved', {
--   group = vim.api.nvim_create_augroup('omerta/auto-hlsearch', { clear = true }),
--   callback = function ()
--     if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
--       vim.schedule(function ()
--         vim.cmd.nohlsearch()
--         vim.cmd.stopinsert()
--       end)
--     end
--   end
-- })

-- https://github.dev/MariaSolOs/dotfiles/blob/f77169cd0622a5893aa47163395d4ddc5ed49290/.config/nvim/lua/commands.lua#L10-L22
vim.api.nvim_create_user_command('Scratch', function()
    vim.cmd 'bel 10new'
    local buf = vim.api.nvim_get_current_buf()
    for name, value in pairs {
        filetype = 'scratch',
        buftype = 'nofile',
        bufhidden = 'wipe',
        swapfile = false,
        modifiable = true,
    } do
        vim.api.nvim_set_option_value(name, value, { buf = buf })
    end
end, { desc = 'Open a scratch buffer', nargs = 0 })
