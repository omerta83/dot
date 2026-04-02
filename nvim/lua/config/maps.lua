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

-- Indent while remaining in visual mode.
map('v', '<', '<gv', { desc = 'Indent left in visual mode' })
map('v', '>', '>gv', { desc = 'Indent right in visual mode' })
-- Move lines up and down in visual mode.
-- map("x", "J", ":m '>+1<CR>gv=gv", { desc = 'Move lines down in visual mode' })
-- map("x", "K", ":m '<-2<CR>gv=gv", { desc = 'Move lines up in visual mode' })
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
map('n', 'yc', 'yygccp', { remap = true })

-- Change in word
map('n', '<C-c>', 'ciw')

-- #/* go back to the first match
-- map('n', '*', '*``')
-- map('n', '#', '#``')

-- Navigating through the quickfix/loclist items.
map('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
map('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
map('n', '[l', '<cmd>lprev<cr>zvzz', { desc = 'Previous loclist item' })
map('n', ']l', '<cmd>lnext<cr>zvzz', { desc = 'Next loclist item' })

map('n', '<bs>', ':b#<CR>', { desc = 'switch to last buffer' })

-- lazy
map("n", "<leader>z", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>.", "<cmd>Scratch<cr>", { desc = "Toggle Scratch Buffer" })

vim.g.status_bar_enabled = true
map("n", "<leader>S", function()
  vim.g.status_bar_enabled = not vim.g.status_bar_enabled
  if vim.g.status_bar_enabled then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end, { desc = "Toggle [S]tatusline" })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end

-- All the ways to start a search, with a description
-- https://www.reddit.com/r/neovim/comments/1k27y0t/go_back_to_the_start_of_a_search_for_the_current/
local mark_search_keys = {
  ["/"] = "Search forward",
  ["?"] = "Search backward",
  ["*"] = "Search current word (forward)",
  ["#"] = "Search current word (backward)",
  -- ["$"] = "Search current word (backward)",
  ["g*"] = "Search current word (forward, not whole word)",
  ["g#"] = "Search current word (backward, not whole word)",
  -- ["g$"] = "Search current word (backward, not whole word)",
}

-- Before starting the search, set a mark `s`
for key, desc in pairs(mark_search_keys) do
  vim.keymap.set("n", key, "ms" .. key, { desc = desc })
end

-- Clear search highlight when jumping back to beginning
vim.keymap.set("n", "`s", function()
  vim.cmd("normal! `s")
  vim.cmd.nohlsearch()
end)
