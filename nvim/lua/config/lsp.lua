local methods = vim.lsp.protocol.Methods
local icons = require('config.icons')
local diagnostic_icons = icons.diagnostics

local M = {}

local function on_attach(client, buffer)
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
  keymap("<leader>ca", vim.lsp.buf.code_action, "[LSP] Code Action on Hover", { "n", "v" })
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
  keymap("<leader>cf", function() require('plugins.lsp.format').format() end, "[LSP] Format Code", { "n", "v" })
  keymap("<leader>cr", vim.lsp.buf.rename, "[LSP] Rename")
  keymap("<leader>ll", "<CMD>LspRestart<CR>", "[LSP] Restart LSP")

  -- Toggle inlay hints
  if client.supports_method(methods.textDocument_inlayHint) then
    vim.keymap.set('n', '<leader>ch', function()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buffer }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })

      -- If toggling them on, turn them back off when entering insert mode.
      if not enabled then
        vim.api.nvim_create_autocmd('InsertEnter', {
          buffer = buffer,
          once = true,
          callback = function()
            vim.lsp.inlay_hint.enable(false, { bufnr = buffer })
          end,
        })
      end
    end, { buffer = buffer, desc = '[LSP] Toggle inlay hints' })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf
    if not client then
      return
    end

    -- Setup keymaps
    on_attach(client, buffer)

    -- Setup vetur document formatting
    if client.name == 'vuels' then
      client.server_capabilities.documentFormattingProvider = true
    end
  end,
})

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostic_icons) do
  local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end
vim.diagnostic.config({
  signs = false, -- no signs in the gutter
  underline = true,
  severity_sort = true,
  -- virtual_text = false,
  -- Steal from https://github.com/MariaSolOs/dotfiles/blob/b08f8cd1e5699c1dcd2e14e1515bc96a4a7abd40/.config/nvim/lua/lsp.lua#L109-L139
  virtual_text = {
    prefix = '',
    spacing = 2,
    format = function(diagnostic)
      -- Use shorter, nicer names for some sources:
      local special_sources = {
        ['Lua Diagnostics.'] = 'lua',
        ['Lua Syntax Check.'] = 'lua',
      }

      local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      if diagnostic.source then
        message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
      end
      if diagnostic.code then
        message = string.format('%s[%s]', message, diagnostic.code)
      end

      return message .. ' '
    end,
  },
  float = {
    source = 'if_many',
    border = 'rounded',
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(' %s', diagnostic_icons[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  }
})

-- Set border for hover popup
vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = 'rounded',
  }
)

return M
