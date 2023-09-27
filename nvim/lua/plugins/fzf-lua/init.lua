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
    { "<leader><space>", FilesPicker.pick,                           desc = "Find files (FzfLua)" },
    { "<leader>fb",      "<cmd>FzfLua buffers<CR>",                  desc = "Buffers (FzfLua)" },
    { "<leader>fg",      "<CMD>FzfLua live_grep_glob<CR>",           desc = "Live Grep --glob (FzfLua)" },
    { "<leader>fp",      "<cmd>FzfLua grep_project<CR>",             desc = "Search all project lines (FzfLua)" },
    { '<leader>fr',      '<cmd>FzfLua oldfiles<cr>',                 desc = 'Recently opened files' },
    { "<leader>f;",      "<cmd>FzfLua resume<CR>",                   desc = "Resume (FzfLua)" },
    { "<leader>fc",      "<cmd>FzfLua commands<CR>",                 desc = "Commands (FzfLua)" },
    { "<leader>fh",      "<cmd>FzfLua command_history<CR>",          desc = "Command history (FzfLua)" },
    { "<leader>fo",      "<cmd>FzfLua lsp_document_symbols<CR>",     desc = "Document symbols (FzfLua)" },
    { "<leader>fO",      "<cmd>FzfLua lsp_workspace_symbols<CR>",    desc = "Workspace symbols (FzfLua)" },
    { "<leader>fa",      "<cmd>FzfLua lsp_code_actions<CR>",         desc = "Code actions (FzfLua)" },
    { "<leader>fd",      "<cmd>FzfLua lsp_document_diagnostic<CR>",  desc = "Document diagnostics (FzfLua)" },
    { "<leader>fD",      "<cmd>FzfLua lsp_workspace_diagnostic<CR>", desc = "Workspace diagnostics (FzfLua)" },
    { '<leader>fvs',     '<cmd>FzfLua git_status<cr>',               desc = 'Git status' },
    { '<leader>fvc',     '<cmd>FzfLua git_commits<cr>',              desc = 'Project git commits' },
    { '<leader>fvb',     '<cmd>FzfLua git_bcommits<cr>',             desc = 'Buffer git commits' },
    { '<leader>fvr',     '<cmd>FzfLua git_branches<cr>',             desc = 'Git branches' },
  },
  opts = function()
    return {
      -- Make stuff better combine with the editor.
      fzf_colors = {
        bg = { 'bg', 'Normal' },
        gutter = { 'bg', 'Normal' },
        info = { 'fg', 'Conditional' },
        scrollbar = { 'bg', 'Normal' },
        separator = { 'fg', 'Comment' },
      },
      fzf_opts = {
        ['--info'] = 'default',
        -- ['--layout'] = 'reverse-list',
      },
      keymap = {
        builtin = {
          ['<C-/>'] = 'toggle-help',
          -- ['<C-a>'] = 'toggle-fullscreen',
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
      previewers = {
        git_diff = {
          pager = 'delta --width=$FZF_PREVIEW_COLUMNS'
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
      global_git_icons = false,
      -- Configuration for specific commands.
      files = {
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
      grep = {
        header_prefix = require('config.icons').misc.Search .. ' ',
      },
      lsp = {
        symbols = {
          symbol_icons = require('config.icons').kinds,
        },
      },
      oldfiles = {
        include_current_session = true,
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)

    -- Add the .gitignore toggle description for the files picker.
    require('fzf-lua.config').set_action_helpstr(FilesPicker.toggle, 'no-ignore<->ignore')
  end
}
