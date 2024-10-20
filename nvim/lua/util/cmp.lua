local M = {}

-- https://github.com/vuejs/language-tools/discussions/4495
local function is_in_start_tag()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return false
  end
  local node_to_check = { 'start_tag', 'self_closing_tag', 'directive_attribute', 'element' }
  return vim.tbl_contains(node_to_check, node:type())
end

-- format: [[abbr]] [[kind (icon + name)]] [[menu (symbol info if available)]]
M.format = function(entry, vim_item)
  local color_item = require('nvim-highlight-colors').format(entry, { kind = vim_item.kind })
  local completion_item = entry:get_completion_item()
  -- Kind icons
  local icons = require('config.icons').kinds
  local kind_icon = ''
  local kind_name = vim_item.kind
  if icons[vim_item.kind] then
    kind_icon = icons[vim_item.kind]
  end
  -- formatting for tailwindcss and highlight colors
  if color_item.abbr_hl_group then
    vim_item.kind_hl_group = color_item.abbr_hl_group
    kind_icon = color_item.abbr
    kind_name = color_item.menu
  end
  vim_item.kind = string.format(' %s %s', kind_icon, kind_name)
  -- symbol info if available
  vim_item.menu = completion_item.detail
  return vim_item
end

-- integration for Vue props and emits
-- https://github.com/vuejs/language-tools/discussions/4495
M.lsp_entry_filter = function(entry, ctx)
  -- TODO: filter out emmet_ls items when not in html for vue, react
  -- https://github.com/hrsh7th/nvim-cmp/issues/806#issuecomment-1207815660

  -- Check if the buffer type is 'vue'
  if ctx.filetype ~= 'vue' then
    return true
  end
  -- Use a buffer-local variable to cache the result of the Treesitter check
  local bufnr = ctx.bufnr
  local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
  if cached_is_in_start_tag == nil then
    vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
  end
  -- If not in start tag, return true
  if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
    return true
  end

  local cursor_before_line = ctx.cursor_before_line
  -- For events
  if cursor_before_line:sub(-1) == '@' then
    return entry.completion_item.label:match('^@')
    -- For props also exclude events with `:on-` prefix
  elseif cursor_before_line:sub(-1) == ':' then
    return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
    -- For slot
  elseif cursor_before_line:sub(-1) == '#' then
    return entry.completion_item.kind == require('cmp.types').lsp.CompletionItemKind.Method
  else
    return true
  end
end

M.clear_cache = function()
  local filetype = vim.bo.filetype
  if filetype ~= 'vue' then
    local bufnr = vim.api.nvim_get_current_buf()
    vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
  end
end

return M
