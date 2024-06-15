local icons = require('config.icons')
return {
  -- which-key
  {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      plugins = { spelling = false },
      window = {
        border = "single",
      },
    },
  },

  -- references
  -- {
  --   "RRethy/vim-illuminate",
  --   event = { "BufReadPost", "BufNewFile" },
  --   opts = {
  --     providers = {
  --       'treesitter',
  --       -- 'lsp'
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

  -- File browser
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
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warning = icons.diagnostics.Warn,
            error = icons.diagnostics.Error
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
            inline_arrows = false,
          },
          highlight_git = true,
          root_folder_modifier = ":~",
          group_empty = true,
          icons = {
            git_placement = "signcolumn",
            show = {
              git = true,
              folder = true,
              file = true,
            },
            glyphs = {
              default = icons.file.default .. " ",
              symlink = icons.file.symlink .. " ",
              git = {
                unstaged = icons.git.unstaged,
                -- unstaged = '+',
                staged = icons.git.staged,
                unmerged = icons.git.unmerged,
                renamed = icons.git.renamed,
                untracked = icons.git.untracked,
                deleted = icons.git.deleted,
                -- untracked = "★"
              },
              folder = icons.folder,
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
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = {
  --     "kevinhwang91/promise-async",
  --   },
  --   event = "BufReadPost",
  --   init = function()
  --     --   -- vim.o.fillchars = [[eob: ,fold:.,foldopen:-,foldsep: ,foldclose:+]]
  --     --   -- vim.o.foldcolumn = "1" -- '0' is not bad
  --     vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  --     vim.o.foldlevelstart = 99
  --     vim.o.foldenable = true
  --     -- https://github.com/kevinhwang91/nvim-ufo/issues/4
  --     vim.o.statuscolumn = '%#FoldColumn#%{'
  --       .. 'foldlevel(v:lnum) > foldlevel(v:lnum - 1)'
  --       .. '? foldclosed(v:lnum) == -1'
  --       .. '? "-"'
  --       .. ': "+"'
  --       .. ': " "'
  --       .. '} %s%=%l '
  --   end,
  --   opts = function()
  --     local handler = function(virtText, lnum, endLnum, width, truncate)
  --       local newVirtText = {}
  --       local suffix = ('   󰁂 %d'):format(endLnum - lnum)
  --       local sufWidth = vim.fn.strdisplaywidth(suffix)
  --       local targetWidth = width - sufWidth
  --       local curWidth = 0
  --       for _, chunk in ipairs(virtText) do
  --         local chunkText = chunk[1]
  --         local chunkWidth = vim.fn.strdisplaywidth(chunkText)
  --         if targetWidth > curWidth + chunkWidth then
  --           table.insert(newVirtText, chunk)
  --         else
  --           chunkText = truncate(chunkText, targetWidth - curWidth)
  --           local hlGroup = chunk[2]
  --           table.insert(newVirtText, { chunkText, hlGroup })
  --           chunkWidth = vim.fn.strdisplaywidth(chunkText)
  --           -- str width returned from truncate() may less than 2nd argument, need padding
  --           if curWidth + chunkWidth < targetWidth then
  --             suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
  --           end
  --           break
  --         end
  --         curWidth = curWidth + chunkWidth
  --       end
  --       table.insert(newVirtText, { suffix, 'MoreMsg' })
  --       return newVirtText
  --     end
  --
  --     return {
  --       fold_virt_text_handler = handler,
  --       -- close_fold_kinds = { "imports", "comment" },
  --       preview = {
  --         mappings = {
  --           scrollU = '<C-u>',
  --           scrollD = '<C-d>',
  --           jumpTop = '[',
  --           jumpBot = ']'
  --         }
  --       },
  --       -- provider_selector = function()
  --       --   return { "treesitter", "indent" }
  --       -- end
  --     }
  --   end,
  --   config = function(_, opts)
  --     local ufo = require('ufo')
  --     ufo.setup(opts)
  --     -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  --     vim.keymap.set("n", "zR", function()
  --       ufo.openAllFolds()
  --     end)
  --     vim.keymap.set("n", "zM", function()
  --       ufo.closeAllFolds()
  --     end)
  --     vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = "Open all folds except kinds" })
  --     vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = "Close all folds with fold level" }) -- closeAllFolds == closeFoldsWith(0)
  --     vim.keymap.set("n", "K", function()
  --       local winid = ufo.peekFoldedLinesUnderCursor()
  --       if not winid then
  --         vim.lsp.buf.hover()
  --       end
  --     end, { desc = "Preview fold" })
  --     -- vim.keymap.set('n', '<CR>', 'za', { desc = "Toggle fold under cursor" })
  --     vim.keymap.set('n', 'zj', ufo.goNextClosedFold, { desc = "Go to next closed fold" })
  --     vim.keymap.set('n', 'zk', ufo.goPreviousClosedFold, { desc = "Go to previous closed fold" })
  --   end,
  -- },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      }
    }
  },

  -- better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    opts = function()
      return {
        func_map = {
          fzffilter = '<leader>qf',
          stoggledown = '<leader>qj',
          stoggleup = '<leader>qk',
        },
        preview = {
          should_preview_cb = function(bufnr)
            local ret = true
            -- disable preview when on Manpage
            if vim.bo[bufnr].filetype == 'man' or vim.bo[bufnr].filetype == 'help' then
              ret = false
            end
            return ret
          end
        }
      }
    end
  },

  {
    'code-biscuits/nvim-biscuits',
    event = "BufReadPost",
    opts = {
      cursor_line_only = true,
      default_config = {
        min_distance = 5,
        prefix_string = " ✨ "
      },
      language_config = {
        vimdoc = {
          disabled = true
        }
      }
    }
  }
}
