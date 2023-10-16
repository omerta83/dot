return {
  -- {
  --   'akinsho/toggleterm.nvim',
  --   version = "*",
  --   cmd = "ToggleTerm",
  --   keys = {
  --     { "<leader>lg", "<cmd>lua LazyGit()<CR>",              desc = "Open LazyGit" },
  --     { "<leader>ld", "<cmd>lua LazyDocker()<CR>",           desc = "Open LazyDocker" },
  --     { "<leader>lt", "<cmd>ToggleTerm direction=float<CR>", desc = "Open Floating Term" },
  --     { "<leader>lf", "<cmd>lua LfPicker()<CR>",             desc = "Open LF" },
  --     { "<C-\\>",     "<cmd>ToggleTerm<CR>",                 desc = "Toggle terminal" }
  --   },
  --   config = function()
  --     local terminal = require("toggleterm")
  --     terminal.setup {
  --       open_mapping = [[<C-\>]],
  --       hide_numbers = true,
  --       highlights = {
  --         -- highlights which map to a highlight group name and a table of it's values
  --         -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
  --         Normal = {
  --           link = "Normal"
  --         },
  --         NormalFloat = {
  --           link = 'NormalFloat'
  --         },
  --         FloatBorder = {
  --           link = "FloatBorder"
  --         },
  --       },
  --     }
  --
  --     -- Lazygit and lazydocker
  --     local function create_float_term(cmd, on_close)
  --       local Terminal = require('toggleterm.terminal').Terminal
  --       local lazy = Terminal:new({
  --         cmd = cmd or '',
  --         direction = "float",
  --         float_opts = {
  --           border = 'rounded'
  --         },
  --         on_open = function(term)
  --           -- vim.cmd("startinsert!")
  --           -- Disable esc when in lazygit or lazydocker
  --           pcall(vim.keymap.del, 't', '<esc>', { buffer = term.bufnr })
  --         end,
  --         -- function to run on closing the terminal
  --         on_close = on_close,
  --         -- on_close = function()
  --         --   vim.cmd("startinsert!")
  --         -- end,
  --       })
  --       return lazy
  --     end
  --     local lazygit = create_float_term("lazygit")
  --     local lazydocker = create_float_term("lazydocker")
  --
  --     function _G.LazyGit()
  --       lazygit:toggle()
  --     end
  --
  --     function _G.LazyDocker()
  --       lazydocker:toggle()
  --     end
  --
  --     -- https://github.com/akinsho/toggleterm.nvim/issues/66#issuecomment-1557373409
  --     function _G.LfPicker()
  --       local lf_temp_path = "/tmp/lfpickerpath"
  --       local lfpicker = create_float_term("lf -selection-path " .. lf_temp_path, function()
  --         local file = io.open(lf_temp_path, "r")
  --         if file == nil then
  --           return
  --         end
  --         local name = file:read("*a")
  --         file:close()
  --         os.remove(lf_temp_path)
  --         local timer = vim.loop.new_timer()
  --         timer:start(
  --           0,
  --           0,
  --           vim.schedule_wrap(function()
  --             vim.cmd("edit " .. name)
  --           end)
  --         )
  --       end)
  --
  --       lfpicker:toggle()
  --     end
  --   end
  -- },

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
      vim.keymap.set('n', '<leader>wh', require('smart-splits').swap_buf_left)
      vim.keymap.set('n', '<leader>wj', require('smart-splits').swap_buf_down)
      vim.keymap.set('n', '<leader>wk', require('smart-splits').swap_buf_up)
      vim.keymap.set('n', '<leader>wl', require('smart-splits').swap_buf_right)
    end
  },
}
