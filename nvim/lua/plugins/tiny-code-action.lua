return {
  {
    'rachartier/tiny-code-action.nvim',
    event = 'LspAttach',
    opts = {
      picker = {
        'buffer',
        opts = { hotkeys = true },
      },
    },
  },
}
