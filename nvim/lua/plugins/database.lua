return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true,
      config = function ()
        -- Autocomplete for vim-dadbod
        require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      end,
    },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  keys = {
    { '<leader>de', ':DBUIToggle<CR>', desc = "[DB] Toggle UI" },
    { '<leader>df', ':DBUIFindBuffer<CR>', desc = "[DB] Find Buffer" },
    { '<leader>dc', ':DBUIAddConnection<CR>', desc = "[DB] Add Connection" },
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
