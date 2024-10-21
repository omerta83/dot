return {
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    main = 'ibl',
    opts = {
      indent = {
        char = "▏",
        priority = 50,
      },
      scope = {
        enabled = true,
        char = "▏",
        show_start = false,
        show_end = false
      },
      whitespace = {
        remove_blankline_trail = true
      },
      exclude = {
        filetypes = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" }
      }
      -- filetype_exclude = { "lspinfo", "packer", "checkhealth", "man", "lazy", "help", "terminal", "mason", "Trouble", "conf", "tmux" },
      -- filetype = require('nvim-treesitter.configs').get_ensure_installed_parsers(), -- keep in sync with nvim-treesitter
      -- use_treesitter = true,
      -- show_trailing_blankline_indent = false,
      -- show_first_indent_level = false,
      -- show_end_of_line = true,
      -- show_current_context = true,
      -- context_char = "▏",
      -- space_char_blankline = " ",
      -- char_priority = 50, -- fix for nvim-ufo integration
    },
    configs = function(_, opts)
      require('ibl').setup(opts)
      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
    end
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
