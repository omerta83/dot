local M = {}

-- TODO: check for client's formatting capabilities
---@param capability string documentFormatting | documentRangeFormatting
function M.format(capability)
  require('conform').format({
    async = true,
    lsp_fallback = true,
    filter = function(client)
      if not client.server_capabilities[capability .. "Provider"] then
        return false
      end
      return true
    end,
  })
end

return M
