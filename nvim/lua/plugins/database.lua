local sql_ft = { "sql", "mysql", "plsql" }
return {
  {
    'tpope/vim-dadbod',
    cmd = 'DB'
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = 'vim-dadbod',
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'vim-dadbod',
    ft = sql_ft,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          local cmp = require("cmp")

          -- global sources
          local sources = vim.tbl_map(function(source)
            return { name = source.name }
          end, cmp.get_config().sources)

          -- add vim-dadbod-completion source
          table.insert(sources, { name = "vim-dadbod-completion" })
          table.insert(sources, { name = "buffer" })

          -- update sources for the current buffer
          cmp.setup.buffer({ sources = sources })
        end,
      })
    end,
  },
}
