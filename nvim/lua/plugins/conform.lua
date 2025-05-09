local biome_or_other = function()
  -- NOTE: Optionally install `prettier-plugin-organize-imports` to
  -- sort/remove unused imports for prettier. Biome seems to have this
  -- built in.
  local cwd = vim.fn.getcwd()
  local has_biome = vim.fn.filereadable(cwd .. '/biome.json')
  local formatters = has_biome == 1 and { 'biome' } or { 'prettier' }

  -- Include rustywind if tailwind.config.js or tailwind.config.ts exists
  local has_tailwind = vim.fn.filereadable(cwd .. '/tailwind.config.js') or
    vim.fn.filereadable(cwd .. '/tailwind.config.ts')
  if has_tailwind == 1 then
    table.insert(formatters, 'rustywind')
  end
  return formatters
end

return {
  {
    'stevearc/conform.nvim',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({
            async = true,
          }, function(err)
            -- Leave visual mode after range format
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end,
        mode = { "n", "v" },
        desc = 'Code [f]ormat',
      }
    },
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = {
        -- fvm dart
        fdart_format = {
          command = "/usr/local/bin/fvm",
          args = { "dart", "format" },
        }
      },
      formatters_by_ft = {
        javascript = biome_or_other,
        javascriptreact = biome_or_other,
        typescript = biome_or_other,
        typescriptreact = biome_or_other,
        vue = biome_or_other,
        lua = { 'stylua' },
        python = { 'ruff_format' },
        -- https://github.com/mvdan/gofumpt (strict gofmt)
        -- https://pkg.go.dev/golang.org/x/tools/cmd/goimports (auto import)
        -- https://github.com/incu6us/goimports-reviser (organize imports)
        go = { 'gofumpt', 'goimports', 'goimports-reviser' },
        dart = { 'fdart_format' },
      }
    },
  },
}
