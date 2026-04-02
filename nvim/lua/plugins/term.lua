return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>gg", "<cmd>lua LazyGit()<CR>",              desc = "Open Lazy[g]it" },
      { "<leader>td", "<cmd>lua LazyDocker()<CR>",           desc = "Open Lazy[d]ocker" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Open [f]loating terminal" },
      { "<C-\\>",     "<cmd>ToggleTerm<CR>",                 desc = "Toggle terminal" },
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
        "lazygit"
        -- function()
        --   vim.cmd("silent! :checktime")
        -- end
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
    -- event = "VeryLazy",
    opts = {
      at_edge = 'stop',
    },
    keys = {
      {'<C-h>', desc = "Move to the left split"},
      {'<C-j>', desc = "Move to the bottom split"},
      {'<C-k>', desc = "Move to the top split"},
      {'<C-l>', desc = "Move to the right split"},

      {'<A-h>', desc = "Resize the left split"},
      {'<A-j>', desc = "Resize the bottom split"},
      {'<A-k>', desc = "Resize the top split"},
      {'<A-l>', desc = "Resize the right split"},

      {'<leader>wh', desc = "Swap buffer left"},
      {'<leader>wj', desc = "Swap buffer down"},
      {'<leader>wk', desc = "Swap buffer up"},
      {'<leader>wl', desc = "Swap buffer right"},
    },
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
