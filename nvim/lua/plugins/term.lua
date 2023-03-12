return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>lg", ":lua LazyGit()<CR>",                  desc = "Open LazyGit" },
      { "<leader>ld", ":lua LazyDocker()<CR>",               desc = "Open LazyDocker" },
      { "<leader>lf", "<cmd>ToggleTerm direction=float<CR>", desc = "Open Floating Term" },
      { "<c-\\>",     ":ToggleTerm<CR>",                     desc = "Toggle terminal" }
    },
    config = function()
      local terminal = require("toggleterm")
      terminal.setup {
        open_mapping = [[<c-\>]],
        hide_numbers = true,
      }

      -- Lazygit and lazydocker
      local function create_float_term(cmd)
        local Terminal = require('toggleterm.terminal').Terminal
        local lazy = Terminal:new({
          cmd = cmd or '',
          direction = "float",
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
          -- function to run on closing the terminal
          on_close = function()
            vim.cmd("startinsert!")
          end,
        })
        return lazy
      end
      local lazygit = create_float_term("lazygit")
      local lazydocker = create_float_term("lazydocker")

      function _G.LazyGit()
        lazygit:toggle()
      end

      function _G.LazyDocker()
        lazydocker:toggle()
      end
    end
  },

  -- Navigate between nvim and tmux
  {
    'numToStr/Navigator.nvim',
    cmd = { "NavigatorRight", "NavigatorLeft", "NavigatorUp", "NavigatorDown" },
    keys = {
      { "<C-h>", '<CMD>NavigatorLeft<CR>',  mode = { 'n', 't' }, desc = "Navigator left" },
      { '<C-l>', '<CMD>NavigatorRight<CR>', mode = { 'n', 't' }, desc = "Navigator right" },
      { '<C-k>', '<CMD>NavigatorUp<CR>',    mode = { 'n', 't' }, desc = "Navigator up" },
      { '<C-j>', '<CMD>NavigatorDown<CR>',  mode = { 'n', 't' }, desc = "Navigator down" },
    },
    config = true
  }
}
