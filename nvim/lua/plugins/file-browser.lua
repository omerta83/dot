local icons = require('config.icons')
return {
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "-",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
      {
        -- Open in the current working directory
        "<leader>fe",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory",
      },
    },
    ---@type YaziConfig
    opts = {
      -- Replacing netrw
      open_for_directories = true,
    },
  },

  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   cmd = 'NvimTreeToggle',
  --   keys = {
  --     { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" }
  --   },
  --   config = function()
  --     -- disable netrw at the very start of your init.lua
  --     vim.g.loaded_netrw = 1
  --     vim.g.loaded_netrwPlugin = 1
  --     local HEIGHT_RATIO = 0.8 -- You can change this
  --     local WIDTH_RATIO = 0.5  -- You can change this too
  --
  --     require('nvim-tree').setup({
  --       auto_reload_on_write = true,
  --       open_on_tab = false,
  --       update_cwd = true,
  --       disable_netrw = true,
  --       hijack_netrw = true,
  --       respect_buf_cwd = true,
  --       sync_root_with_cwd = true,
  --       reload_on_bufenter = true,
  --       update_focused_file = {
  --         enable = true,
  --         update_cwd = true,
  --         ignore_list = { ".git", "node_modules", ".cache" },
  --       },
  --       diagnostics = {
  --         enable = true,
  --         show_on_dirs = true,
  --         icons = {
  --           hint = icons.diagnostics.Hint,
  --           info = icons.diagnostics.Info,
  --           warning = icons.diagnostics.Warn,
  --           error = icons.diagnostics.Error
  --         }
  --       },
  --       filters = {
  --         custom = {
  --           "^.git$",
  --         },
  --       },
  --       view = {
  --         float = {
  --           enable = true,
  --           open_win_config = function()
  --             local screen_w = vim.opt.columns:get()
  --             local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  --             local window_w = screen_w * WIDTH_RATIO
  --             local window_h = screen_h * HEIGHT_RATIO
  --             local window_w_int = math.floor(window_w)
  --             local window_h_int = math.floor(window_h)
  --             local center_x = (screen_w - window_w) / 2
  --             local center_y = ((vim.opt.lines:get() - window_h) / 2)
  --               - vim.opt.cmdheight:get()
  --             return {
  --               border = "rounded",
  --               relative = "editor",
  --               row = center_y,
  --               col = center_x,
  --               width = window_w_int,
  --               height = window_h_int,
  --             }
  --           end,
  --         },
  --         width = function()
  --           return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
  --         end,
  --       },
  --       renderer = {
  --         indent_markers = {
  --           enable = true,
  --           inline_arrows = false,
  --         },
  --         highlight_git = true,
  --         root_folder_modifier = ":~",
  --         group_empty = true,
  --         icons = {
  --           git_placement = "signcolumn",
  --           show = {
  --             git = true,
  --             folder = true,
  --             file = true,
  --           },
  --           glyphs = {
  --             default = icons.file.default .. " ",
  --             symlink = icons.file.symlink .. " ",
  --             git = {
  --               unstaged = icons.git.unstaged,
  --               -- unstaged = '+',
  --               staged = icons.git.staged,
  --               unmerged = icons.git.unmerged,
  --               renamed = icons.git.renamed,
  --               untracked = icons.git.untracked,
  --               deleted = icons.git.deleted,
  --               -- untracked = "★"
  --             },
  --             folder = icons.folder,
  --           }
  --         },
  --       },
  --       git = {
  --         enable = true,
  --         ignore = true,
  --         timeout = 400,
  --       },
  --       actions = {
  --         use_system_clipboard = true,
  --         open_file = {
  --           quit_on_open = false
  --         }
  --       },
  --     })
  --   end
  -- },
  -- {
  --   'stevearc/oil.nvim',
  --   cmd = "Oil",
  --   keys = {
  --     { "-", function() require('oil').open_float() end, desc = "Open parent directory in float" },
  --     -- { "q", function() require("oil").close() end,      desc = "Close Oil" },
  --   },
  --   opts = {
  --     delete_to_trash = true,
  --     keymaps = {
  --       ["<C-y>"] = "actions.preview",
  --     },
  --     float = {
  --       max_width = 100,
  --       max_height = 80
  --     }
  --   },
  --   -- Optional dependencies
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  -- },
}
