return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        symbol = "󱏿", -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = "#38BDF8",
        },
      },
      custom_filetypes = {}
    }
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    event = { "BufReadPre *.html,*.js,*.ts,*.jsx,*.tsx,*.vue", "BufNewFile *.html,*.js,*.ts,*.jsx,*.tsx,*.vue" },
    -- keys = {
    --   { "<leader>tv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    -- },
    opts = {
      border = "rounded",          -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
      focus_preview = false,       -- Sets the preview as the current window
      copy_register = "",          -- The register to copy values to,
      -- keymaps = {
      --   copy = "<C-y>"               -- Normal mode keymap to copy the CSS values between {}
      -- }
    },
    config = function(_, opts)
      require('tw-values').setup(opts)
      vim.keymap.set("n", "<leader>tv", "<cmd>TWValues<cr>", { desc = "Show tailwind CSS values" })
    end
  },
}
