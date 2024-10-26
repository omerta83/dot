local map = require('util').map

-- Use j for gj and k for gk when wrapping is enabled.
-- if vim.o.wrap then
--   map("n", "j", [[v:count ? 'j' : 'gj']], { expr = true })
--   map("n", "k", [[v:count ? 'k' : 'gk']], { expr = true })
-- end

-- Keeping the cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
-- Keep search results at the center of screen
-- map("n", "n", "nzzzv", { silent = true })
-- map("n", "N", "Nzzzv", { silent = true })
map('n', 'n', function()
  vim.cmd('silent normal! nzzzv')
  vim.schedule_wrap(function()
    require('lualine').refresh({
      place = { "statusline" }
    })
  end)
end, { desc = 'Move to next search result' })
map('n', 'N', function()
  vim.cmd('silent normal! Nzzzv')
  vim.schedule_wrap(function()
    require('lualine').refresh({
      place = { "statusline" }
    })
  end)
end, { desc = 'Move to previous search result' })

-- Indent while remaining in visual mode.
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Navigating through the quickfix/loclist items.
map('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
map('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
map('n', '[l', '<cmd>lprev<cr>zvzz', { desc = 'Previous loclist item' })
map('n', ']l', '<cmd>lnext<cr>zvzz', { desc = 'Next loclist item' })

-- Comment text objects
-- local comment = require('vim._comment')
-- map('x', 'ic', comment.textobject)
-- map('o', 'ic', comment.textobject)

-- #/* go back to the first match
map('n', '*', '*``')
map('n', '#', '#``')

-- lazy
map("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Clear search with <esc>.
map('n', '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end
