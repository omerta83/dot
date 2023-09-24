local map = require('util').map
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- COPY EVERYTHING --
map("n", "<A-a>", [[ <Cmd> %y+<CR>]], { silent = true })

-- Keep search results at the center of screen
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })

-- Remap paste with indentation
map("n", "p", "]p", { silent = true })
map("n", "P", "[p", { silent = true })

-- lazy
map("n", "<leader>lz", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Moving between windows using their numbers
for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  map("n", lhs, rhs, { desc = "Move to window " .. i })
end

-- Terminal / ToggleTerm
function _G.set_terminal_keymaps()
  local lopts = { buffer = 0 }
  map('t', '<esc>', [[<C-\><C-n>]], lopts)
  map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], lopts)
  map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], lopts)
  map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], lopts)
  map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], lopts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')

-- Treesitter textobjects
-- vim way: ; goes to the direction you were moving.
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

-- LSP
-- local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next,
--   vim.diagnostic.goto_prev)
-- local next_error, prev_error = ts_repeat_move.make_repeatable_move_pair(
--   function()
--     vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })
--   end,
--   function()
--     vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })
--   end
-- )
-- local next_warning, prev_warning = ts_repeat_move.make_repeatable_move_pair(
--   function()
--     vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.WARN })
--   end,
--   function()
--     vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN })
--   end
-- )
-- utils.map("n", "]d", next_diagnostic, { desc = "Next diagnostic" })
-- utils.map("n", "[d", prev_diagnostic, { desc = "Previous diagnostic" })
-- utils.map("n", "]e", next_error, { desc = "Next error" })
-- utils.map("n", "[e", prev_error, { desc = "Previous error" })
-- utils.map("n", "]w", next_warning, { desc = "Next warning" })
-- utils.map("n", "[w", prev_warning, { desc = "Previous warning" })
-- utils.map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration [LSP]", noremap = true, silent = true })
-- utils.map("n", "gr", vim.lsp.buf.references, { desc = "Go to references [LSP]", noremap = true, silent = true })
-- utils.map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation [LSP]", noremap = true, silent = true })
-- utils.map({ "i", "n" },
--   "<c-s>",
--   vim.lsp.buf.signature_help,
--   {
--     desc = "Signature help [LSP]",
--     noremap = true,
--     silent = true
--   })
-- utils.map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
