-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/fzf-lua.lua
-- Custom files picker with toggling for respecting/ignoring .gitignore.
local FilesPicker = {
  opts = nil,
  ignoring = nil,
}
FilesPicker.toggle = function(_, _)
  FilesPicker.pick(FilesPicker.opts)
end
FilesPicker.pick = function(opts)
  if not opts then
    FilesPicker.ignoring = true
  end
  opts = opts or {}
  opts.actions = {
    ['ctrl-g'] = FilesPicker.toggle,
  }
  local behavior = ''
  if FilesPicker.ignoring then
    behavior = 'respecting'
    opts.cmd = 'fd --color=never --no-require-git --type f --hidden --follow --exclude .git' -- always respect .gitignore even if no .git folder exists
  else
    behavior = 'ignoring'
    opts.cmd = 'fd --color=never --type f --hidden --follow --no-ignore'
  end
  opts.winopts = {
    title = ' Files (' .. behavior .. ' .gitignore) ',
    title_pos = 'center',
  }
  FilesPicker.ignoring = not FilesPicker.ignoring
  FilesPicker.opts = opts

  require('fzf-lua').files(opts)
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader><space>", FilesPicker.pick,                            desc = "Find files (FzfLua)" },
    { "<leader>fb",      "<cmd>FzfLua buffers<CR>",                   desc = "Buffers (FzfLua)" },
    { "<leader>fg",      "<CMD>FzfLua live_grep_glob<CR>",            desc = "Live Grep --glob (FzfLua)" },
    { "<leader>fp",      "<cmd>FzfLua grep_project<CR>",              desc = "Search all project lines (FzfLua)" },
    { '<leader>fr',      '<cmd>FzfLua oldfiles<cr>',                  desc = 'Recently opened files' },
    { "<leader>f;",      "<cmd>FzfLua resume<CR>",                    desc = "Resume (FzfLua)" },
    { "<leader>fc",      "<cmd>FzfLua commands<CR>",                  desc = "Commands (FzfLua)" },
    { "<leader>fh",      "<cmd>FzfLua command_history<CR>",           desc = "Command history (FzfLua)" },
    { "<leader>fM",      "<cmd>FzfLua man_pages<CR>",                 desc = "Man page (FzfLua)" },
    { "<leader>f?",      "<cmd>FzfLua help_tags<CR>",                 desc = "Help tags (FzfLua)" },
    { "<leader>fo",      "<cmd>FzfLua lsp_document_symbols<CR>",      desc = "Document symbols (FzfLua)" },
    { "<leader>fO",      "<cmd>FzfLua lsp_workspace_symbols<CR>",     desc = "Workspace symbols (FzfLua)" },
    { "<leader>fa",      "<cmd>FzfLua lsp_code_actions<CR>",          desc = "Code actions (FzfLua)" },
    { "<leader>fd",      "<cmd>FzfLua lsp_document_diagnostics<CR>",  desc = "Document diagnostics (FzfLua)" },
    { "<leader>fD",      "<cmd>FzfLua lsp_workspace_diagnostics<CR>", desc = "Workspace diagnostics (FzfLua)" },
    { '<leader>fvs',     '<cmd>FzfLua git_status<cr>',                desc = 'Git status' },
    { '<leader>fvc',     '<cmd>FzfLua git_commits<cr>',               desc = 'Project git commits' },
    { '<leader>fvb',     '<cmd>FzfLua git_bcommits<cr>',              desc = 'Buffer git commits' },
    { '<leader>fvr',     '<cmd>FzfLua git_branches<cr>',              desc = 'Git branches' },
  },
  opts = function()
    local actions = require "fzf-lua.actions"
    local preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$FZF_PREVIEW_COLUMNS"
    local icons = require('config.icons')

    return {
      "fzf-native",
      -- for performance
      global_git_icons  = false,
      -- global_file_icons = false,
      file_icon_padding = ' ',
      fzf_opts          = {
        ['--info'] = 'default',
        ['--pointer'] = icons.misc.Arrow,
        ['--marker'] = '✓',
      },
      keymap            = {
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ["<A-/>"] = "toggle-help",
          ["<F2>"]  = "toggle-fullscreen",
          -- Only valid with the 'builtin' previewer
          ["<F3>"]  = "toggle-preview-wrap",
          ["<C-y>"] = "toggle-preview",
          -- Rotate preview clockwise/counter-clockwise
          -- ["<F5>"]     = "toggle-preview-ccw",
          -- ["<F6>"]     = "toggle-preview-cw",
          -- ["<C-f>"]    = "preview-page-down",
          -- ["<C-b>"]    = "preview-page-up",
          -- ["<S-left>"] = "preview-page-reset",
        },
        fzf = {
          -- fzf '--bind=' options
          ["ctrl-z"] = "abort",
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-f"] = "preview-page-down",
          ["ctrl-b"] = "preview-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["ctrl-s"] = "jump-accept",
          ["alt-a"]  = "toggle-all",
          ["ctrl-l"] = "clear-selection",
          -- Only valid with fzf previewers (bat/cat/git/etc)
          ["f3"]     = "toggle-preview-wrap",
          ["ctrl-y"] = "toggle-preview",
        },
      },
      actions           = {
        files = {
          -- ["default"]     = actions.file_edit,
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-x"]  = actions.file_split,
          ["ctrl-v"]  = actions.file_vsplit,
          ["ctrl-t"]  = actions.file_tabedit,
          ["ctrl-q"]  = actions.file_sel_to_qf,
          ["alt-l"]   = actions.file_sel_to_ll,
        },
        buffers = {
          ["default"] = actions.buf_edit,
          -- ["ctrl-x"]  = actions.buf_split,
          ["ctrl-v"]  = actions.buf_vsplit,
          ["ctrl-t"]  = actions.buf_tabedit,
        }
      },
      previewers        = {
        git_diff = {
          pager = preview_pager
        },
      },
      winopts           = {
        height = 0.75,
        width = 0.5,
        preview = {
          -- defer the execution of bat to fzf
          -- default = 'bat_native',
          scrollbar = false,
          delay = 100,
          hidden = 'hidden',
          layout = 'vertical',
          vertical = 'down:45%',
        },
      },
      -- Configuration for specific commands.
      files             = {
        cwd_prompt = false,
        prompt = 'Files❯ ',
      },
      git               = {
        status = {
          prompt = 'Git Status❯ ',
          winopts = {
            preview = { hidden = 'nohidden' },
          },
          actions = {
            ["right"]  = false,
            ["left"]   = false,
            ["ctrl-x"] = actions.file_split, -- remap reset key
            ["ctrl-h"] = { fn = actions.git_stage_unstage, reload = true },
          }
        },
        commits = {
          prompt = 'Git Commits❯ ',
          preview_pager = preview_pager,
        },
        bcommits = {
          prompt = 'Buffer Commits❯ ',
          preview_pager = preview_pager,
        }
      },
      grep              = {
        prompt = 'Grep❯ ',
        header_prefix = icons.misc.Search .. ' ',
      },
      lsp               = {
        prompt_postfix = '❯ ',
        cwd_only = true,
        symbols = {
          prompt_postfix = '❯ ',
          symbol_icons = icons.kinds,
        },
        code_actions = {
          prompt = 'Code Actions❯ ',
        }
      },
      diagnostics       = {
        prompt = 'Diagnostics❯ ',
      },
      oldfiles          = {
        prompt = 'Recent Files❯ ',
        cwd_only = true,
        include_current_session = true,
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
      buffers           = {
        prompt = 'Buffers❯ ',
        cwd_only = true,
        actions = {
          ["ctrl-x"] = actions.buf_split,
          ["ctrl-d"] = { fn = actions.buf_del, reload = true },
        }
      },
      manpages          = {
        cmd = "man -k -S 1 -M /usr/local/share/man .",
        prompt = 'Man❯ ',
      },
      helptags          = {
        prompt = 'Help❯ ',
      },
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)

    -- Add the .gitignore toggle description for the files picker.
    require('fzf-lua.config').set_action_helpstr(FilesPicker.toggle, 'no-ignore<->ignore')
  end
}
