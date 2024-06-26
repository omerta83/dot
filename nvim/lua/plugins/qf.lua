return {
  -- better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = function()
      return {
        func_map = {
          fzffilter = '<leader>xf',
          -- stoggledown = '<leader>xj',
          -- stoggleup = '<leader>xk',
          -- sclear = '<leader>xc',
        },
        preview = {
          should_preview_cb = function(bufnr)
            local ret = true
            -- disable preview when on Manpage
            if vim.bo[bufnr].filetype == 'man' or vim.bo[bufnr].filetype == 'help' then
              ret = false
            end
            return ret
          end
        }
      }
    end
  },
}
