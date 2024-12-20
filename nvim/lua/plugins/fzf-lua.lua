return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  event = "VeryLazy",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<CR>",                      desc = "[FzfLua] Find files" },
    {
      "<leader>ff",
      function()
        require 'fzf-lua'.files({ cwd = vim.fn.expand('%:p:h') })
      end,
      desc = "[FzfLua] Find files in current folder"
    },
    { "<leader>fb",      "<cmd>FzfLua buffers<CR>",                    desc = "[FzfLua] Buffers" },
    { '<leader>f/',      '<cmd>FzfLua lgrep_curbuf<CR>',               desc = 'Grep current buffer' },
    { "<leader>fg",      "<CMD>FzfLua live_grep_glob<CR>",             desc = "[FzfLua] Live Grep --glob" },
    { "<leader>fg",      "<CMD>FzfLua grep_visual<CR>",                desc = "[FzfLua] Live Grep --glob",        mode = 'x' },
    { "<leader>fp",      "<cmd>FzfLua grep_project<CR>",               desc = "[FzfLua] Search all project lines" },
    { '<leader>fr',      '<cmd>FzfLua oldfiles<cr>',                   desc = '[FzfLua] Recently opened files' },
    { "<leader>f;",      "<cmd>FzfLua resume<CR>",                     desc = "[FzfLua] Resume" },
    { "<leader>fc",      "<cmd>FzfLua commands<CR>",                   desc = "[FzfLua] Commands" },
    { "<leader>fh",      "<cmd>FzfLua command_history<CR>",            desc = "[FzfLua] Command history" },
    { "<leader>fM",      "<cmd>FzfLua man_pages<CR>",                  desc = "[FzfLua] Man page" },
    { "<leader>f?",      "<cmd>FzfLua help_tags<CR>",                  desc = "[FzfLua] Help tags" },
    { "<leader>fo",      "<cmd>FzfLua lsp_document_symbols<CR>",       desc = "[FzfLua] Document symbols" },
    -- { "<leader>fO", "<cmd>FzfLua lsp_workspace_symbols<CR>",      desc = "[FzfLua] Workspace symbols" },
    { "<leader>fO",      "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "[FzfLua] Live workspace symbols" },
    { "<leader>fa",      "<cmd>FzfLua lsp_code_actions<CR>",           desc = "[FzfLua] Code actions" },
    { "<leader>fd",      "<cmd>FzfLua lsp_document_diagnostics<CR>",   desc = "[FzfLua] Document diagnostics" },
    { "<leader>fD",      "<cmd>FzfLua lsp_workspace_diagnostics<CR>",  desc = "[FzfLua] Workspace diagnostics" },
    { '<leader>fm',      "<cmd>FzfLua marks<CR>",                      desc = "[FzfLua] Marks" },
    { '<leader>fy',      '<cmd>FzfLua registers<CR>',                  desc = '[FzfLua] Registers' },
    { '<leader>fk',      "<cmd>FzfLua keymaps<CR>",                    desc = "[FzfLua] Keymaps" },
    { '<leader>fY',      "<cmd>FzfLua tmux_buffers<CR>",               desc = "[FzfLua] Show tmux yank history" },
    { '<leader>gt',      '<cmd>FzfLua git_status<cr>',                 desc = '[FzfLua] Git status' },
    { '<leader>gC',      '<cmd>FzfLua git_commits<cr>',                desc = '[FzfLua] Git project commits' },
    { '<leader>gc',      '<cmd>FzfLua git_bcommits<cr>',               desc = '[FzfLua] Git buffer commits' },
    -- { '<leader>gb',      '<cmd>FzfLua git_branches<cr>',               desc = '[FzfLua] Git branches' },
  },
  opts = function()
    local actions = require "fzf-lua.actions"
    local icons = require('config.icons')

    return {
      "fzf-native",
      -- for performance
      global_git_icons  = false,
      -- global_file_icons = false,
      file_icon_padding = ' ',
      fzf_opts          = {
        ['--layout'] = 'reverse-list',
      },
      keymap            = {
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ["<A-/>"] = "toggle-help",
          ["<C-t>"] = "toggle-fullscreen",
          -- Only valid with the 'builtin' previewer
          ["<F3>"]  = "toggle-preview-wrap",
          ["<C-/>"] = "toggle-preview",
        },
        fzf = {
          -- fzf '--bind=' options
          ["ctrl-z"] = "abort",
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"]  = "toggle-all",
          ["ctrl-l"] = "clear-selection",
          ['ctrl-q'] = 'select-all+accept',
          -- Only valid with fzf previewers (bat/cat/git/etc)
          ["f3"]     = "toggle-preview-wrap",
          ["ctrl-/"] = "toggle-preview",
        },
      },
      actions           = {
        files = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-x"]  = actions.file_split,
          ["ctrl-v"]  = actions.file_vsplit,
          ["ctrl-t"]  = actions.file_tabedit,
          ["alt-l"]   = actions.file_sel_to_ll,
        },
        buffers = {
          ["default"] = actions.buf_edit,
          -- ["ctrl-x"]  = actions.buf_split,
          ["ctrl-v"]  = actions.buf_vsplit,
          ["ctrl-t"]  = actions.buf_tabedit,
        }
      },
      winopts           = {
        height = 0.7,
        width = 0.5,
        preview = {
          -- defer the execution of bat to fzf
          -- default = 'bat_native',
          scrollbar = false,
          delay = 100,
          hidden = 'hidden',
          layout = 'vertical',
          vertical = 'up:55%',
        },
      },
      -- Configuration for specific commands.
      files             = {
        cwd_prompt = false,
      },
      git               = {
        status = {
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
      },
      lsp               = {
        cwd_only = true, -- LSP/diagnostics for cwd only?
        symbols = {
          symbol_icons = icons.kinds,
        },
      },
      oldfiles          = {
        cwd_only = true,
        include_current_session = true,
        winopts = {
          preview = { hidden = 'hidden' },
        },
      },
      buffers           = {
        cwd_only = true,
        actions = {
          ["ctrl-x"] = actions.buf_split,
          ["ctrl-d"] = { fn = actions.buf_del, reload = true },
        }
      },
      manpages          = {
        cmd = "man -k -S 1 -M /usr/local/share/man .",
      },
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end
}
