return {
  -- which-key
  {
    "folke/which-key.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      plugins = { spelling = false },
      window = {
        border = "single",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '┃' },
        topdelete = { text = '┃' },
        changedelete = { text = '┃' },
      },
      trouble = false,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    -- "TimUntersberger/neogit",
    'NeogitOrg/neogit',
    cmd = "Neogit",
    opts = {
      integrations = {
        diffview = true
      }
    }
  },
  -- references
  -- {
  --   "RRethy/vim-illuminate",
  --   event = { "BufReadPost", "BufNewFile" },
  --   opts = {
  --     providers = {
  --       'lsp',
  --       'treesitter'
  --     },
  --     delay = 200,
  --     filetypes_denylist = {
  --       'dirvish',
  --       'fugitive',
  --       'NvimTree',
  --       'toggleterm',
  --       'TelescopePrompt',
  --       'DiffviewFiles',
  --       "lazy",
  --       "mason",
  --     }
  --   },
  --   config = function(_, opts)
  --     require("illuminate").configure(opts)
  --     vim.api.nvim_create_autocmd("FileType", {
  --       -- reset ]] and [[
  --       callback = function()
  --         local buffer = vim.api.nvim_get_current_buf()
  --         pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
  --         pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
  --       end,
  --     })
  --   end,
  --   keys = {
  --     { "]]", function() require("illuminate").goto_next_reference() end, desc = "Next Reference", },
  --     { "[[", function() require("illuminate").goto_prev_reference() end, desc = "Prev Reference" },
  --   },
  -- },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    },
  },

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    keys = {
      { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" }
    },
    config = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      local HEIGHT_RATIO = 0.8 -- You can change this
      local WIDTH_RATIO = 0.5  -- You can change this too

      local icons = require('config.icons').diagnostics

      require('nvim-tree').setup({
        auto_reload_on_write = true,
        open_on_tab = false,
        update_cwd = true,
        disable_netrw = true,
        hijack_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
        update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = { ".git", "node_modules", ".cache" },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = icons.Hint,
            info = icons.Info,
            warning = icons.Warn,
            error = icons.Error
          }
        },
        filters = {
          custom = {
            "^.git$",
          },
        },

        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
                - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
          highlight_git = true,
          root_folder_modifier = ":~",
          icons = {
            git_placement = "signcolumn",
            show = {
              git = true,
              folder = true,
              file = true,
            },
            glyphs = {
              default = " ",
              symlink = " ",
              git = {
                unstaged = '',
                -- unstaged = '+',
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = '',
                deleted = '󰍴'
                -- untracked = "★"
              },
              folder = {
                -- default = "",
                -- open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = ""
              }
            }
          },
        },
        git = {
          enable = true,
          ignore = true,
          timeout = 400,
        },
        actions = {
          use_system_clipboard = true,
          open_file = {
            quit_on_open = false
          }
        },
      })
    end
  },
  {
    'stevearc/oil.nvim',
    cmd = "Oil",
    keys = {
      { "-", function() require('oil').open_float() end, desc = "Open parent directory in float" },
      -- { "q", function() require("oil").close() end,      desc = "Close Oil" },
    },
    opts = {
      float = {
        max_width = 100,
        max_height = 80
      }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- add nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    init = function()
    --   -- vim.o.fillchars = [[eob: ,fold:.,foldopen:-,foldsep: ,foldclose:+]]
    --   -- vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      -- https://github.com/kevinhwang91/nvim-ufo/issues/4
      vim.o.statuscolumn = '%#FoldColumn#%{'
        .. 'foldlevel(v:lnum) > foldlevel(v:lnum - 1)'
          .. '? foldclosed(v:lnum) == -1'
            .. '? "-"'
            .. ': "+"'
          .. ': " "'
      .. '} %s%=%l '
    end,
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('   󰁂 %d'):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      return {
        fold_virt_text_handler = handler,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        },
        -- provider_selector = function()
        --   return { "treesitter", "indent" }
        -- end
      }
    end,
    config = function(_, opts)
      local ufo = require('ufo')
      ufo.setup(opts)
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function()
        ufo.openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        ufo.closeAllFolds()
      end)
      vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = "Open all folds except kinds" })
      vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = "Close all folds with fold level" }) -- closeAllFolds == closeFoldsWith(0)
      vim.keymap.set("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Preview fold" })
      vim.keymap.set('n', '<CR>', 'za', { desc = "Toggle fold under cursor" })
      vim.keymap.set('n', 'zj', ufo.goNextClosedFold, { desc = "Go to next closed fold" })
      vim.keymap.set('n', 'zk', ufo.goPreviousClosedFold, { desc = "Go to previous closed fold" })
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    config = function()
      require("fidget").setup({
        window = {
          blend = 0,
        },
        text = {
          done = require('config.icons').misc.Check
        }
      })
    end
  },

  -- {
  --   "DNLHC/glance.nvim",
  --   cmd = "Glance",
  --   keys = {
  --     { "<leader>gld", "<CMD>Glance definitions<CR>", desc = "Glance definitions" },
  --     { "<leader>glr", "<CMD>Glance references<CR>", desc = "Glance references" },
  --     { "<leader>gly", "<CMD>Glance type_definitions<CR>", desc = "Glance type definitions" },
  --     { "<leader>glm", "<CMD>Glance implementations<CR>", desc=" Glance implementations" }
  --   },
  --   opts = {
  --     border = {
  --       enable = true
  --     }
  --   }
  -- }
}
