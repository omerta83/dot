local M = {}

function M.on_attach(client, buffer)
  local function keymap(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end

  keymap("gD", vim.lsp.buf.declaration, "Go to declaration [LSP]")
  keymap("gd", vim.lsp.buf.definition, "Go to definition [LSP]")
  keymap("gr", vim.lsp.buf.references, "Go to references [LSP]")
  keymap("gi", vim.lsp.buf.implementation, "Go to implementation [LSP]")
  keymap("<c-s>", vim.lsp.buf.signature_help, "Signature help [LSP]", { "i", "n" })
  keymap("K", vim.lsp.buf.hover, "Hover")
  keymap("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
  keymap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
  keymap("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  keymap("]e", function() vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Next Error")
  keymap("[e", function() vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Prev Error")
  keymap("]w", function() vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Next Warning")
  keymap("[w", function() vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Prev Warning")
  keymap("<leader>cf", function() require('plugins.lsp.format').format("documentFormatting") end, "Format Document")
  keymap("<leader>cf", function() require('plugins.lsp.format').format("documentRangeFormatting") end, "Format Range",
    { "n", "v" })
  keymap("<Leader>ca", vim.lsp.buf.code_action, "Code Action [LSP]", { "n", "v" })
  keymap("<Leader>cl", "<CMD>LspRestart<CR>", "Restart LSP")
end

return M
