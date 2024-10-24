local M = {}

function M.format()
  require('conform').format({
    async = true,
    lsp_fallback = true,
    filter = function(client)
      if not client.server_capabilities["documentFormattingProvider"] or not client.server_capabilities["documentRangeFormattingProvider"] then
        return false
      end
      return true
    end,
  }, function(err)
    -- Leave visual mode after range format
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end

return M
