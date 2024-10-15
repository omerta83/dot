local M = {}

function M.on_attach(_, buffer)
  local function keymap(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end

  keymap("gD", vim.lsp.buf.declaration, "[LSP] Go to declaration")
  keymap("gd", vim.lsp.buf.definition, "[LSP] Go to definition")
  keymap("gr", vim.lsp.buf.references, "[LSP] Go to references")
  keymap("gi", vim.lsp.buf.implementation, "[LSP] Go to implementation")
  keymap("<c-s>", vim.lsp.buf.signature_help, "[LSP] Signature help", { "i", "n" })
  keymap("K", vim.lsp.buf.hover, "[LSP] Hover")
  keymap("<leader>ca", vim.lsp.buf.code_action, "[LSP] Code Action", { "n", "v" })
  keymap("<leader>K", vim.diagnostic.open_float, "Line Diagnostics")
  keymap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")
  keymap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev Diagnostic")
  keymap("]e", function() vim.diagnostic.jump({ count = 1, wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Next Error")
  keymap("[e", function() vim.diagnostic.jump({ count = -1, wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Prev Error")
  keymap("]w", function() vim.diagnostic.jump({ count = 1, wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Next Warning")
  keymap("[w", function() vim.diagnostic.jump({ count = -1, wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Prev Warning")
  keymap("<leader>cf", function() require('plugins.lsp.format').format("documentFormatting") end, "Format Document")
  keymap("<leader>cf", function() require('plugins.lsp.format').format("documentRangeFormatting") end, "Format Range",
    { "n", "v" })
  keymap("<leader>rn", vim.lsp.buf.rename, "[LSP] Rename")
  keymap("<leader>ll", "<CMD>LspRestart<CR>", "[LSP] Restart LSP")
end

return M
