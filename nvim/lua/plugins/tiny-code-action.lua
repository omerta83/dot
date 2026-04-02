return {
  {
    'rachartier/tiny-code-action.nvim',
    event = 'LspAttach',
    opts = {
      picker = {
        'buffer',
        opts = {
          hotkeys = true,
          -- Numeric hotkeys
          hotkeys_mode = function(titles)
            local t = {}
            for i = 1, #titles do t[i] = tostring(i) end
            return t
          end
        },
      },
    },
  },
}
