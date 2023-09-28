-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/fzf-lua.lua
-- Custom files picker with toggling for respecting/ignoring .gitignore.
local FilesPicker = {
  opts = nil,
  ignoring = nil,
}
local fzf_opts = {
  ['--info'] = 'inline',
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
  opts.fzf_opts = fzf_opts
  local behavior = ''
  if FilesPicker.ignoring then
    behavior = 'respecting'
    opts.cmd = 'fd --color=never --type f --hidden --follow --exclude .git'
  else
    behavior = 'ignoring'
    opts.cmd = 'fd --color=never --type f --hidden --follow --no-ignore'
  end
  opts.winopts = {
    title = 'Files (' .. behavior .. ' .gitignore)',
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
    return {
      -- for performance
      global_git_icons = false,
      global_file_icons = false,
      fzf_opts = fzf_opts,
      keymap = {
        builtin = {
          ['<A-/>'] = 'toggle-help',
          ['<C-a>'] = 'toggle-preview',
          ['<C-f>'] = 'preview-page-down',
          ['<C-b>'] = 'preview-page-up',
        },
        fzf = {
          ['alt-s'] = 'toggle',
          ['alt-a'] = 'toggle-all',
          ['ctrl-a'] = 'toggle-preview'
        },
      },
      actions = {
        -- These override the default tables completely
        -- no need to set to `false` to disable an action
        -- delete or modify is sufficient
        files = {
          -- providers that inherit these actions:
          --   files, git_files, git_status, grep, lsp
          --   oldfiles, quickfix, loclist, tags, btags
          --   args
          -- default action opens a single selection
          -- or sends multiple selection to quickfix
          -- replace the default action with the below
          -- to open all files whether single or multiple
          -- ["default"]     = actions.file_edit,
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-s"]  = actions.file_split,
          ["ctrl-v"]  = actions.file_vsplit,
          ["ctrl-t"]  = actions.file_tabedit,
          ["ctrl-q"]  = actions.file_sel_to_qf,
          ["ctrl-l"]  = actions.file_sel_to_ll,
        },
        buffers = {
          -- providers that inherit these actions:
          --   buffers, tabs, lines, blines
          ["default"] = actions.buf_edit,
          ["ctrl-s"]  = actions.buf_split,
          ["ctrl-v"]  = actions.buf_vsplit,
          ["ctrl-t"]  = actions.buf_tabedit,
        }
      },
      previewers = {
        git_diff = {
          pager = preview_pager
        }
      },
      winopts = {
        height = 0.7,
        width = 0.55,
        preview = {
          scrollbar = false,
          hidden = 'hidden',
          layout = 'vertical',
          -- vertical = 'down:45%',
        },
      },
      -- Configuration for specific commands.
      files = {
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
      git = {
        status = {
          actions = {
            ["right"]  = false,
            ["left"]   = false,
            -- ["ctrl-l"] = { fn = actions.git_unstage, reload = true },
            -- ["ctrl-h"] = { fn = actions.git_stage, reload = true },
            ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
          }
        },
        commits = {
          preview_pager = preview_pager,
        },
        bcommits = {
          preview_pager = preview_pager,
        }
      },
      grep = {
        header_prefix = require('config.icons').misc.Search .. ' ',
        fzf_opts = fzf_opts,
      },
      lsp = {
        cwd_only = true,
        symbols = {
          symbol_icons = require('config.icons').kinds,
        },
      },
      oldfiles = {
        cwd_only = true,
        include_current_session = true,
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
      buffers = {
        cwd_only = true,
      }
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)

    -- Add the .gitignore toggle description for the files picker.
    require('fzf-lua.config').set_action_helpstr(FilesPicker.toggle, 'no-ignore<->ignore')
  end
}
