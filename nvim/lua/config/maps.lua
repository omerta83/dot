local map = require('util').map

-- Keep search results at the center of screen
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })

-- Remap paste with indentation
map("n", "p", "]p", { silent = true })
map("n", "P", "[p", { silent = true })

local silent_mods = { mods = { silent = true, emsg_silent = true } }
vim.keymap.set('n', '<leader>xq', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose(silent_mods)
  elseif #vim.fn.getqflist() > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.copen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd 'p'
    end
  end
end, { desc = 'Toggle quickfix list' })
vim.keymap.set('n', '<leader>xl', function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose(silent_mods)
  elseif #vim.fn.getloclist(0) > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.lopen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd 'p'
    end
  end
end, { desc = 'Toggle location list' })
-- ...and navigating through the items.
vim.keymap.set('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[l', '<cmd>lprev<cr>zvzz', { desc = 'Previous loclist item' })
vim.keymap.set('n', ']l', '<cmd>lnext<cr>zvzz', { desc = 'Next loclist item' })

-- close with q
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
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

-- lazy
map("n", "<leader>lz", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end

-- Terminal / ToggleTerm
function Set_terminal_keymaps()
  local lopts = { buffer = 0 }
  map('t', '<esc>', [[<C-\><C-n>]], lopts)
  map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], lopts)
  map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], lopts)
  map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], lopts)
  map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], lopts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm* lua Set_terminal_keymaps()')
