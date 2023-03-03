return {
  -- Fuzzy finder with fzf
  {
    'ibhagwan/fzf-lua',
    cmd = { "FzfLua" },
    keys = function()
      return {
        {
          "<Leader><space>",
          function()
            require('fzf-lua').files({
              { cmd = vim.env.FZF_DEFAULT_COMMAND }
            })
          end,
          desc = "Find files (root dir)",
        },
        { "<Leader>fb", "<cmd>FzfLua buffers<CR>",               desc = "Buffers (FZF)" },
        { "<Leader>fg", "<cmd>FzfLua live_grep_native<CR>",      desc = "Live Grep Args (FZF)" },
        { "<Leader>fs", "<cmd>FzfLua grep<CR>",                  desc = "Grep String (FZF)" },
        { "<Leader>fv", "<cmd>FzfLua git_commits<CR>",           desc = "Git Commits (FZF)" },
        { "<leader>fh", "<cmd>FzfLua command_history<cr>",       desc = "Command History (FZF)" },
        { "<leader>fc", "<cmd>FzfLua commands<cr>",              desc = "Commands (FZF)" },
        { "<Leader>fo", "<cmd>FzfLua lsp_document_symbols<CR>",  desc = "Goto Symbol (FZF)" },
        { '<Leader>f;', "<cmd>FzfLua resume<CR>",                desc = "Resume (FZF)" },
        { '<Leader>fd', "<cmd>FzfLua diagnostics_document<CR>",  desc = "Show Document Diagnostics (FZF)" },
        { '<Leader>fD', "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Show Workspace Diagnostics (FZF)" },
        {
          '<Leader>ft',
          function()
            require('fzf-lua').fzf_exec("tldr --list", {
              prompt = "tldr> ",
              fzf_opts = {
                  ['--preview-window'] = 'right,50%'
              },
              preview = "tldr {1}",
            })
          end,
          desc = "tldr"
        },
        {
          '<Leader>st',
          function()
            local Config = require("todo-comments.config")
            local Highlight = require("todo-comments.highlight")
            local Search = require("todo-comments.search")

            local builtin = require("fzf-lua.previewer.builtin")
            local TodoPreviewer = builtin.buffer_or_file:extend()
            function TodoPreviewer:new(o, opts, fzf_win)
              TodoPreviewer.super.new(self, o, opts, fzf_win)
              setmetatable(self, TodoPreviewer)
              return self
            end
            function TodoPreviewer:parse_entry(entry_str)
              -- minus the icon and the space in front
              local path, line, col = entry_str:sub(6):match("([^:]+):?([0-9]*):?([0-9]*)")
              return {
                path = path,
                line = tonumber(line),
                col = tonumber(col),
              }
            end

            local function todo(cb)
              -- TODO: highlight entry
              Search.search(function(results)
                for _, item in ipairs(results) do
                  local display = string.format("%s:%s:%s ", item.filename, item.lnum, item.col)
                  local text = item.text
                  local start, finish, kw = Highlight.match(text)

                  local hl = {}

                  if start then
                    kw = Config.keywords[kw] or kw
                    local icon = Config.options.keywords[kw].icon
                    display = icon .. " " .. display
                    table.insert(hl, { { 1, #icon + 1 }, "TodoFg" .. kw })
                    text = vim.trim(text:sub(start))

                    table.insert(hl, {
                      { #display, #display + finish - start + 2 },
                      "TodoBg" .. kw
                    })
                    table.insert(hl, {
                      { #display + finish - start + 1, #display + finish + 1 + #text },
                      "TodoFg" .. kw
                    })
                    display = display .. " " .. text
                  end

                  cb(display)
                  -- return display, hl
                end
                cb(nil)
              end)
            end

            coroutine.wrap(function()
              require('fzf-lua').core.fzf_files({
                prompt = "Todo> ",
                previewer = TodoPreviewer
              }, todo)
            end)()
            -- require('fzf-lua').fzf_exec(
            --   function(fzf_cb)
            --     todo(fzf_cb)
            --   end,
            --   {
            --     prompt = "Todo> ",
            --     previewer = TodoPreviewer
            --   }
            -- )
          end,
          desc = "Todo"
        }
      }
    end,
    opts = function()
      local preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$FZF_PREVIEW_COLUMNS"
      -- local preview_pager = vim.fn.executable("delta") == 1 and "delta --side-by-side -w ${FZF_PREVIEW_COLUMNS:-$COLUMNS}"
      local fzf_lua = require('fzf-lua')
      return {
        "fzf-native",
        winopts = {
          height  = 0.85,
          width   = 0.80,
          row     = 0.35,
          col     = 0.55,
          preview = {
            layout = 'vertical'
          },
        },
        previewers = {
          git_diff = {
            pager = preview_pager,
          },
        },
        git = {
          status = {
            cmd = "git status -su",
            winopts = {
              preview = { vertical = "down:70%", horizontal = "right:70%" }
            },
            actions = { ["ctrl-x"] = { fzf_lua.actions.git_reset, fzf_lua.actions.resume } },
            preview_pager = preview_pager,
          },
          commits = {
            winopts = {
              preview = { vertical = "down:60%", }
            },
            preview_pager = preview_pager
          },
          bcommits = {
            winopts = {
              preview = { vertical = "down:60%", }
            },
            preview_pager = preview_pager
          },
          branches = {
            winopts = {
              preview = { vertical = "down:75%", horizontal = "right:75%", }
            }
          }
        },
        fzf_opts = {
          -- ['--bind']         = 'ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down',
          -- ['--no-separator'] = '',
            ['--ansi'] = '',
            ['--info'] = 'inline',
            ['--height'] = '100%',
            ['--layout'] = 'reverse',
            ['--border'] = 'none',
        },
        fzf_colors = {
            ["fg"] = { "fg", "Normal" },
            ["fg+"] = { "fg", "Normal" },
            ["bg+"] = { "bg", "CursorLine" },
            ["info"] = { "fg", "FzfLuaTitle" },
            ["prompt"] = { "fg", "FzfLuaTitle" },
            ["header"] = { "fg", "Normal" },
            ["gutter"] = { "bg", "Normal" },
          -- ["scrollbar"] = { "fg", "WarningMsg" },
        },
        file_icon_padding = '',
        keymap = {
          fzf = {
              ["ctrl-z"]   = "abort",
            -- ["ctrl-u"]     = "unix-line-discard",
              ["ctrl-f"]   = "half-page-down",
              ["ctrl-b"]   = "half-page-up",
              ["ctrl-a"]   = "beginning-of-line",
              ["ctrl-e"]   = "end-of-line",
              ["alt-a"]    = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
              ["ctrl-d"]   = "preview-half-page-down",
              ["ctrl-u"]   = "preview-half-page-up",
              ["f3"]       = "toggle-preview-wrap",
              ["f4"]       = "toggle-preview",
              ["shift-down"] = "preview-page-down",
              ["shift-up"] = "preview-page-up",
          }
        }
      }
    end
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
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
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
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
      -- signs                        = {
      --   add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      --   change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      --   delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      --   topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      --   changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      -- },
      -- signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
      -- numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      -- linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      -- word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      -- watch_gitdir                 = {
      --   interval = 1000,
      --   follow_files = true
      -- },
      -- attach_to_untracked          = true,
      -- current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      -- current_line_blame_opts      = {
      --   virt_text = true,
      --   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      --   delay = 1000,
      --   ignore_whitespace = false,
      -- },
      -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      -- sign_priority                = 6,
      -- update_debounce              = 100,
      -- status_formatter             = nil, -- Use default
      -- max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      -- preview_config               = {
      --   -- Options passed to nvim_open_win
      --   border = 'single',
      --   style = 'minimal',
      --   relative = 'cursor',
      --   row = 0,
      --   col = 1
      -- },
      -- yadm                         = {
      --   enable = false
      -- },
    },
    -- config = function()
    --   require('gitsigns').setup {
    --   }
    --
    -- vim.cmd "hi DiffAdd guifg=#81A1C1 guibg = none"
    -- vim.cmd "hi DiffChange guifg =#3A3E44 guibg = none"
    -- vim.cmd "hi DiffModified guifg = #81A1C1 guibg = none"
    -- end
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      filetypes_denylist = {
        'dirvish',
        'fugitive',
        'NvimTree',
        'toggleterm',
        'TelescopePrompt',
        'DiffviewFiles'
      }
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
          pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
        end,
      })
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
    end,
    -- stylua: ignore
    keys = {
      { "]]", function() require("illuminate").goto_next_reference() end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference() end, desc = "Prev Reference" },
    },
  },

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
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      -- { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    },
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        tag = "v1.5",
        keys = {
          {
            "<Leader>ww",
            function()
              local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
              vim.api.nvim_set_current_win(picked_window_id)
            end,
            desc = "Pick a window"
          }
        },
        config = function()
          require 'window-picker'.setup({
            autoselect_one = true,
            include_current_win = false,
            selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            show_prompt = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" },
              },
            },
            -- other_win_hl_color = '#e35e4f',
          })
        end,
      }
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added     = "",  -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified  = "",  -- or "", but this is redundant info if you use git_status_colors on the name
            deleted   = "✖", -- this can only be used in the git_status source
            renamed   = "", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
          }
        },
        icon = {
          folder_empty = ""
        }
      },
      filesystem = {
        visible = true,
        bind_to_cwd = false,
        follow_current_file = true,
        filtered_items = {
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".DS_Store",
          },
        }
      },
      window = {
        mappings = {
            ["<space>"] = "none",
        },
      },
    },
  },
}
