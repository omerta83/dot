local map = require('util').map

-- Use j for gj and k for gk when wrapping is enabled.
if vim.o.wrap then
  map("n", "j", [[v:count ? 'j' : 'gj']], { expr = true })
  map("n", "k", [[v:count ? 'k' : 'gk']], { expr = true })
end

-- Keeping the cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
-- Keep search results at the center of screen
map("n", "n", "nzzzv", { desc = 'Next result', silent = true })
map("n", "N", "Nzzzv", { desc = 'Prev result', silent = true })
-- map('n', 'n', function()
--   vim.cmd('silent normal! nzzzv')
-- end, { desc = 'Move to next search result' })
-- map('n', 'N', function()
--   vim.cmd('silent normal! Nzzzv')
-- end, { desc = 'Move to previous search result' })

-- Indent while remaining in visual mode.
map('v', '<', '<gv', { desc = 'Indent left in visual mode' })
map('v', '>', '>gv', { desc = 'Indent right in visual mode' })
-- Move lines up and down in visual mode. 
map("x", "J", ":m '>+1<CR>gv=gv", { desc = 'Move lines down in visual mode' })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = 'Move lines up in visual mode' })
-- Join lines and retain the cursor position
map("n", "J", "mzJ`z")
-- Paste replace text but keep pasted text in the unamed register and discard the replaced text
-- into the black hole register.
map("x", "<leader>p", [["_dP]], { desc = "Paste replace and keep pasted text" })

-- Insert new line in normal mode
map('n', '<leader>oo', 'm`o<Esc>``', { desc = 'Open new line bel[o]w in normal mode' })
map('n', '<leader>oO', 'm`O<Esc>``', { desc = '[O]pen new line above in normal mode' })

-- Clear search highlights and command-line text with <esc>.
map('n', '<esc>', '<cmd>stopinsert<bar>noh<cr><esc>')

-- Duplicate a line and comment out the first one
vim.keymap.set('n', 'yc', 'yygccp', { remap = true })

-- Change in word
vim.keymap.set('n', '<C-c>', 'ciw')

-- #/* go back to the first match
-- map('n', '*', '*``')
-- map('n', '#', '#``')

-- Navigating through the quickfix/loclist items.
map('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
map('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
map('n', '[l', '<cmd>lprev<cr>zvzz', { desc = 'Previous loclist item' })
map('n', ']l', '<cmd>lnext<cr>zvzz', { desc = 'Next loclist item' })

vim.keymap.set('n', '<bs>', ':b#<CR>', { desc = 'switch to last buffer' })

-- lazy
map("n", "<leader>z", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end
