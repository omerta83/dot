return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>gg", "<cmd>lua LazyGit()<CR>",              desc = "[ToggleTerm] Open LazyGit" },
      { "<leader>td", "<cmd>lua LazyDocker()<CR>",           desc = "[ToggleTerm] Open LazyDocker" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "[ToggleTerm] Open Floating Term" },
      { "<C-\\>",     "<cmd>ToggleTerm<CR>",                 desc = "[ToggleTerm] Toggle terminal" }
    },
    config = function()
      local terminal = require("toggleterm")
      terminal.setup {
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = false,
      }

      -- Lazygit and lazydocker
      local function create_float_term(cmd, on_exit)
        local Terminal = require('toggleterm.terminal').Terminal
        local lazy = Terminal:new({
          cmd = cmd or '',
          direction = "float",
          hidden = true,
          float_opts = {
            border = 'rounded'
          },
          on_open = function()
            -- Disable esc when in lazygit or lazydocker
            vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<Esc>', { noremap = true, silent = true })
            -- vim.keymap.del('t', '<esc>')
          end,
          -- function to run on closing the terminal
          on_exit = on_exit,
        })
        return lazy
      end
      local lazygit = create_float_term(
        "lazygit",
        function()
          vim.cmd("silent! :checktime")
        end
      )
      local lazydocker = create_float_term("lazydocker")

      function _G.LazyGit()
        lazygit:toggle()
      end

      function _G.LazyDocker()
        lazydocker:toggle()
      end

      -- Terminal window mappings
      function _G.set_terminal_keymaps(buffer)
        local lopts = { buffer = buffer }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], lopts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], lopts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], lopts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], lopts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], lopts)
      end

      vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
    end
  },

  -- Navigate between nvim and tmux/kitty/wezterm
  {
    'mrjones2014/smart-splits.nvim',
    -- lazy = false, -- disable lazy when using with wezterm
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require('smart-splits').setup(opts)
      -- resizing splits
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      -- swapping buffers between windows
      vim.keymap.set(
        'n',
        '<leader>wh',
        function() require('smart-splits').swap_buf_left({ move_cursor = true }) end,
        { desc = "Swap buffer left" }
      )
      vim.keymap.set(
        'n',
        '<leader>wj',
        function() require('smart-splits').swap_buf_down({ move_cursor = true }) end,
        { desc = "Swap buffer down" }
      )
      vim.keymap.set(
        'n',
        '<leader>wk',
        function() require('smart-splits').swap_buf_up({ move_cursor = true }) end,
        { desc = "Swap buffer up" }
      )
      vim.keymap.set(
        'n',
        '<leader>wl',
        function() require('smart-splits').swap_buf_right({ move_cursor = true }) end,
        { desc = "Swap buffer right" }
      )
    end
  },
}
