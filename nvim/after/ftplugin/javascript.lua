vim.keymap.set(
  "n",
  "<leader>co",
  "<cmd>VtsExec organize_imports<CR>",
  { desc = "[Typescript] Organize Imports" }
)
vim.keymap.set(
  "n",
  "<leader>cd",
  "<cmd>VtsExec goto_source_definition<CR>",
  { desc = "[Typescript] Go To Source Definition" }
)
vim.keymap.set(
  "n",
  "<leader>ci",
  "<cmd>VtsExec add_missing_imports<CR>",
  { desc = "[Typescript] Add Missing Imports" }
)
vim.keymap.set(
  "n",
  "<leader>cu",
  "<cmd>VtsExec remove_unused<CR>",
  { desc = "[Typescript] Remove Unused Imports" }
)
vim.keymap.set(
  "n",
  "<leader>cn",
  "<cmd>VtsExec rename_file<CR>",
  { desc = "[Typescript] Rename File" }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>VtsExec file_references<CR>",
  { desc = "[Typescript] File References" }
)
vim.keymap.set(
  "n",
  "<leader>cF",
  "<cmd>VtsExec fix_all<CR>",
  { desc = "[Typescript] Fix All Errors" }
)
