local keymap = vim.keymap

-- vim.g.mapleader = " "

-- keymap.set("", "<leader>c", '"+y')
-- keymap.set("n", "<leader>l<Enter>", [[<Cmd>vnew<CR> term://zsh <CR>]])
-- keymap.set("n", "<leader>j<Enter>", [[<Cmd> split term://zsh | resize 10 <CR>]]) -- open term bottom
-- keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>:bd!<CR>") -- Close terminal

-- COPY EVERYTHING --
keymap.set("n", "<A-a>", [[ <Cmd> %y+<CR>]])

-- Keep search results at the center of screen
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

-- Remap paste with indentation
keymap.set("n", "p", "]p")
keymap.set("n", "P", "[p")

-- lazy
keymap.set("n", "<leader>lz", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  keymap.set("n", lhs, rhs, { desc = "Move to window " .. i })
end

-- Splits
-- keymap.set("n", "<leader>hn", ":leftabove vnew<CR>", {noremap = true, silent = true})
-- keymap.set("n", "<Leader>ln", ":rightbelow vnew<CR>", {noremap = true, silent = true})
-- keymap.set("n", "<Leader>kn", ":leftabove  new<CR>", {noremap = true, silent = true})
-- keymap.set("n", "<Leader>jn", ":rightbelow new<CR>", {noremap = true, silent = true})

-- Terminal / ToggleTerm
function _G.set_terminal_keymaps()
  local lopts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], lopts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], lopts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], lopts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], lopts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], lopts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')
