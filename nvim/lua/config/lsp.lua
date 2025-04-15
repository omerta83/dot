local methods = vim.lsp.protocol.Methods
local icons = require('config.icons')
local diagnostic_icons = icons.diagnostics

local M = {}

local function on_attach(client, buffer)
  local function keymap(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end

  keymap("gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", "[G]oto [D]efinition")
  keymap("gR", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", "[G]oto [R]eference")
  keymap("gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", "[G]oto [I]mplementation")
  keymap("gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", "[G]oto T[y]pe Definition")
  keymap("<c-s>", function()
    vim.lsp.buf.signature_help({
      border = 'rounded',
      focusable = false,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    })
  end, "Signature help", { "i", "n" })
  keymap("K", function()
    vim.lsp.buf.hover({
      border = 'rounded',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    })
  end, "Hover")
  keymap("<leader>ca", vim.lsp.buf.code_action, "Show code [a]ctions on Hover", { "n", "v" })
  keymap("<leader>K", vim.diagnostic.open_float, "Line Diagnostics")
  keymap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next [d]iagnostic")
  keymap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev [d]iagnostic")
  keymap("]e", function() vim.diagnostic.jump({ count = 1, wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Next [e]rror")
  keymap("[e", function() vim.diagnostic.jump({ count = -1, wrap = true, severity = vim.diagnostic.severity.ERROR }) end,
    "Prev [e]rror")
  keymap("]w", function() vim.diagnostic.jump({ count = 1, wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Next [w]arning")
  keymap("[w", function() vim.diagnostic.jump({ count = -1, wrap = true, severity = vim.diagnostic.severity.WARN }) end,
    "Prev [w]arning")
  -- keymap("<leader>cf", function() require('plugins.lsp.format').format() end, "Code [f]ormat", { "n", "v" })
  keymap("<leader>cr", vim.lsp.buf.rename, "Symbol [r]ename")

  -- https://github.com/nvim-lua/kickstart.nvim/blob/de44f491016126204824fac2b5a7d7e544a769be/init.lua#L549C11-L576C14
  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client and client:supports_method(methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('omerta/lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buffer,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buffer,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('omerta/lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'omerta/lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  -- Toggle inlay hints
  if client:supports_method(methods.textDocument_inlayHint) then
    -- <leader>ci already used for vtsls for filetype autocmd
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
    end, { buffer = buffer, desc = 'Toggle inlay [h]ints' })
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

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local server_configs = vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ':t:r')
      end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

return M
