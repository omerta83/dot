local map = require('util').map

-- Use j for gj and k for gk when wrapping is enabled.
-- if vim.o.wrap then
--   map("n", "j", [[v:count ? 'j' : 'gj']], { expr = true })
--   map("n", "k", [[v:count ? 'k' : 'gk']], { expr = true })
-- end

-- Keeping the cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
-- Keep search results at the center of screen
map("n", "n", "nzzzv", { silent = true })
map("n", "N", "Nzzzv", { silent = true })

-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

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

-- Navigating through the quickfix/loclist items.
vim.keymap.set('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[l', '<cmd>lprev<cr>zvzz', { desc = 'Previous loclist item' })
vim.keymap.set('n', ']l', '<cmd>lnext<cr>zvzz', { desc = 'Next loclist item' })

-- Comment text objects
local comment = require('vim._comment')
vim.keymap.set('x', 'ic', comment.textobject)
vim.keymap.set('o', 'ic', comment.textobject)

-- searching for the word under the cursor goes back to the first match
vim.keymap.set('n', '*', '*``')
vim.keymap.set('n', '#', '#``')

-- lazy
map("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Clear search with <esc>.
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end
