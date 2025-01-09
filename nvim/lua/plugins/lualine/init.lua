return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    end
  end,
  opts = function()
    local components = require('plugins/lualine/components')

    return {
      options = {
        theme = require('util.lualine').theme(),
        component_separators = '',
        section_separators = '',
        globalstatus = true,
        -- refresh = {
        --   statusline = 0, -- avoid flickering when refresh
        -- },
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha", "TelescopePrompt", "mason", "lspinfo", "fzf" }
        },
      },
      sections = {
        lualine_a = {
          components.mode,
          -- components.logo,
          -- components.space,
        },
        lualine_b = {
          components.filename,
          components.filetype,
          -- components.space,
          components.branch,
          -- components.diff,
          -- components.tasks,
        },
        lualine_c = {
          -- components.space,
          -- components.tasks,
            -- components.lsp_symbols,
        },
        lualine_x = {
          -- components.marco_recording,
          -- components.space,
          -- components.searchcount,
        },
        lualine_y = {
          components.encoding,
          components.fileformat,
          -- components.space,
          components.lsp,
        },
        lualine_z = {
          -- components.dia,
          -- components.lsp,
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {
        require('plugins.lualine.extensions').term,
      },
    }
  end,
}
