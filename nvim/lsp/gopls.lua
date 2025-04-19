local mod_cache = nil

---@param fname string
---@return string?
local function get_root(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, { 'go.work', 'go.mod', '.git' })
end

---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    if mod_cache then
      on_dir(get_root(fname))
      return
    end
    local cmd = { 'go', 'env', 'GOMODCACHE' }
    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 then
        if output.stdout then
          mod_cache = vim.trim(output.stdout)
        end
        on_dir(get_root(fname))
      else
        vim.notify(('[gopls] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
      end
    end)
  end,
  -- init_options = {
  --   usePlaceholders = true,
  -- },
  settings = {
    gopls = {
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      completeUnimported = true,
      vulncheck = "Imports",
      staticcheck = true,
      semanticTokens = true,
      analyses = {
        shadow = true,
        fillreturns = true,
        nonewvars = true,
        staticcheck = true,
        structure = true,
        unparam = true,
        deadcode = true,
        nilness = true,
        typeparams = true,

        unusedwrite = true,
        unusedparams = true,
        unusedresult = true,
      },
      codelenses = {
        references = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        regenerate_cgo = true,
        generate = true,
        gc_details = false,
        run_govulncheck = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    }
  },
}
