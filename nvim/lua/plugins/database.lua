-- local sql_ft = { "sql", "mysql", "plsql" }
return {
  -- {
  --   'tpope/vim-dadbod',
  --   cmd = 'DB'
  -- },
  {
    'kristijanhusak/vim-dadbod-ui',
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = {
      { 'tpope/vim-dadbod' },
      { 'kristijanhusak/vim-dadbod-completion' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_bind_param_pattern="\\$\\d\\+"
      vim.g.db_ui_winwidth = 60
      vim.g.db_ui_show_database_icon = true
      -- Use <leader>S to execute query
      vim.g.db_ui_execute_on_save = false
    end,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
  },
  -- {
  --   'kristijanhusak/vim-dadbod-completion',
  --   -- dependencies = 'vim-dadbod',
  --   ft = sql_ft,
  --   -- init = function()
  --   --   vim.api.nvim_create_autocmd("FileType", {
  --   --     pattern = sql_ft,
  --   --     callback = function()
  --   --       -- local cmp = require("cmp")
  --   --       --
  --   --       -- -- global sources
  --   --       -- local sources = vim.tbl_map(function(source)
  --   --       --   return { name = source.name }
  --   --       -- end, cmp.get_config().sources)
  --   --       --
  --   --       -- -- add vim-dadbod-completion source
  --   --       -- table.insert(sources, { name = "vim-dadbod-completion" })
  --   --       -- table.insert(sources, { name = "buffer" })
  --   --       --
  --   --       -- -- update sources for the current buffer
  --   --       -- cmp.setup.buffer({ sources = sources })
  --   --     end,
  --   --   })
  --   -- end,
  -- },
}
