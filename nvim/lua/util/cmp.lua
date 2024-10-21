local M = {}

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
  -- TODO: filter out emmet_ls items when not in html for react
  -- https://github.com/hrsh7th/nvim-cmp/issues/806#issuecomment-1207815660

  -- Check if the buffer type is 'vue'
  if ctx.filetype ~= 'vue' then
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

-- for blink.cmp
-- TailwindCSS color highlighting
-- https://github.com/NvChad/ui/blob/87578bb7e2bc106127f013f9a1edd7a716f4f6c6/lua/nvchad/cmp/format.lua#L6
-- Adapted from this PR: https://github.com/Saghen/blink.cmp/pull/143
local function try_get_tailwind_hl(ctx)
  local doc = ctx.item.documentation
  if ctx.kind == 'Color' and doc then
    local content = type(doc) == 'string' and doc or doc.value
    if ctx.kind == 'Color' and content and content:match('^#%x%x%x%x%x%x$') then
      local hl_name = 'HexColor' .. content:sub(2)
      if #vim.api.nvim_get_hl(0, { name = hl_name }) == 0 then
        vim.api.nvim_set_hl(0, hl_name, { fg = content })
      end
      return hl_name
    end
  end
end
-- Draw function for blink.cmp
-- format: [[abbr]] [[kind (icon + name)]] [[menu (symbol info if available)]]
M.draw = function(ctx)
  local completion_item = ctx.item
  local kind_icon = ctx.kind == 'Color' and '󱓻' or ctx.kind_icon
  -- space separator for detail - one or nothing if no detail to preserve alignment
  local detail_gap = completion_item.detail and ' ' or ''
  local components = {
    ' ',
    {
      ctx.label,
      ctx.kind == 'Snippet' and '~' or nil,
      fill = true,
      hl_group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel',
      max_width = 50,
    },
    ' ',
    {
      ctx.icon_gap,
      kind_icon,
      ctx.icon_gap,
      ctx.kind,
      hl_group = try_get_tailwind_hl(ctx) or ('BlinkCmpKind' .. ctx.kind),
    },
    ' ',
    {
      detail_gap,
      completion_item.detail,
      hl_group = 'CmpItemMenu',
      detail_gap
    }
  }

  return components
end

return M
