local M = {}

---@type string documentFormatting | documentRangeFormatting
-- TODO: check for client's formatting capabilities
function M.format(type)
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require('null-ls.sources').get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      if not client.server_capabilities[type .. "Provider"] then
        return false
      end

      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end
  }, {
    -- async = true,
    formatting_options = nil,
    timeout_ms = nil,
  }))
end

return M
