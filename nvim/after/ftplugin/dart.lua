vim.keymap.set(
  "n",
  "<leader>cl",
  "<cmd>FlutterLogToggle<CR>",
  { desc = "[Flutter] Toggle Log" }
)
vim.keymap.set(
  "n",
  "<leader>cd",
  "<cmd>FlutterRun<CR>",
  { desc = "[Flutter] Run / Deploy" }
)
vim.keymap.set(
  "n",
  "<leader>ce",
  "<cmd>FlutterEmulators<CR>",
  { desc = "[Flutter] Emulators" }
)
vim.keymap.set(
  "n",
  "<leader>cE",
  "<cmd>FlutterDevices<CR>",
  { desc = "[Flutter] Devices" }
)
vim.keymap.set(
  "n",
  "<leader>cp",
  "<cmd>FlutterPubGet<CR>",
  { desc = "[Flutter] Pub Get" }
)
