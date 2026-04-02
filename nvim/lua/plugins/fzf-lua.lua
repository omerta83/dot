local icons = require('config.icons')

-- return {
--   'nvim-telescope/telescope.nvim',
--   tag = 'v0.2.0',
--   cmd = "Telescope",
--   dependencies = { 'nvim-lua/plenary.nvim' },
--   keys = {
--     { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
--     { "<leader>fb",      "<cmd>Telescope buffers<CR>",    desc = "List [b]uffers" },
--     { "<leader>fg",      "<cmd>Telescope live_grep<CR>",  desc = "Live [g]rep" },
--     { "<leader>fp",      "<cmd>Telescope grep_string<CR>",desc = "Search [p]roject Lines" },
--     { "<leader>fr",      "<cmd>Telescope oldfiles<CR>",   desc = "[r]ecently opened files" },
--     { "<leader>f;",      "<cmd>Telescope resume<CR>",     desc = "Resume" },
--     { "<leader>fc",      "<cmd>Telescope commands<CR>",   desc = "List [c]ommands" },
--     { "<leader>fh",      "<cmd>Telescope command_history<CR>", desc = "Command [h]istory" },
--     { "<leader>f?",      "<cmd>Telescope help_tags<CR>", desc = "[?] Help tags" },
--   }
-- }

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  -- dependencies = 'elanmed/fzf-lua-frecency.nvim',
  -- event = "VeryLazy",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<CR>",        desc = "Find files" },
    { "<leader>fb",      "<cmd>FzfLua buffers<CR>",      desc = "List [b]uffers" },
    { '<leader>f/',      '<cmd>FzfLua lgrep_curbuf<CR>', desc = 'Grep current buffer' },
    { "<leader>fg",      "<CMD>FzfLua live_grep<CR>",    desc = "Live [g]rep --glob" },
    { "<leader>fg",      "<CMD>FzfLua grep_visual<CR>",  desc = "Live [g]rep --glob",    mode = 'x' },
    { "<leader>fp",      "<cmd>FzfLua grep_project<CR>", desc = "Search [p]roject Lines" },
    {
      "<leader>fr",
      function()
        require('fzf-lua').oldfiles()
      end,
      desc = "[r]ecently opened files"
    },
    { "<leader>f;", "<cmd>FzfLua resume<CR>",                     desc = "Resume" },
    { "<leader>fc", "<cmd>FzfLua commands<CR>",                   desc = "List [c]ommands" },
    { "<leader>fh", "<cmd>FzfLua command_history<CR>",            desc = "Command [h]istory" },
    { "<leader>fM", "<cmd>FzfLua man_pages<CR>",                  desc = "[M]an Pages" },
    { "<leader>f?", "<cmd>FzfLua help_tags<CR>",                  desc = "[?] Help tags" },
    { "<leader>fo", "<cmd>FzfLua lsp_document_symbols<CR>",       desc = "Document symb[o]ls" },
    { "<leader>fO", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Live workspace symb[O]ls" },
    { "<leader>fa", "<cmd>FzfLua lsp_code_actions<CR>",           desc = "Code [a]ctions" },
    { "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<CR>",   desc = "Document [d]iagnostics" },
    { "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<CR>",  desc = "Workspace [D]iagnostics" },
    { '<leader>fm', "<cmd>FzfLua marks<CR>",                      desc = "List [m]arks" },
    { '<leader>fs', '<cmd>FzfLua registers<CR>',                  desc = 'List regi[s]ters' },
    { '<leader>fk', "<cmd>FzfLua keymaps<CR>",                    desc = "List [k]eymaps" },
    { '<leader>fy', "<cmd>FzfLua tmux_buffers<CR>",               desc = "Show tmux yank histor[y]" },
    { '<leader>gt', '<cmd>FzfLua git_status<cr>',                 desc = 'Git s[t]atus with FZF' },
    { '<leader>gC', '<cmd>FzfLua git_commits<cr>',                desc = 'Git project [C]ommits with FZF' },
    { '<leader>gc', '<cmd>FzfLua git_bcommits<cr>',               desc = 'Git buffer [c]ommits with FZF' },
    { '<leader>gm', '<cmd>FzfLua git_diff<cr>',                   desc = 'Show git [m]odified files with FZF' },
  },
  opts = function()
    local actions = require "fzf-lua.actions"

    return {
      "fzf-native",
      { 'border-fused', 'hide' },
      defaults   = {
        git_icons = false,
        file_icons = 'devicons',
      },
      fzf_opts   = {
        -- ['--info'] = 'default',
        ['--layout'] = 'reverse-list',
      },
      keymap     = {
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ["<A-/>"] = "toggle-help",
          ["<C-t>"] = "toggle-fullscreen",
          ['<C-f>'] = 'preview-page-down',
          ['<C-b>'] = 'preview-page-up',
          -- Only valid with the 'builtin' previewer
          -- ["<F3>"]  = "toggle-preview-wrap",
          ["<C-i>"] = "toggle-preview",
        },
        fzf = {
          -- ["ctrl-z"] = "abort",
          -- ["ctrl-u"] = "unix-line-discard",
          -- ["ctrl-a"] = "beginning-of-line",
          -- ["ctrl-e"] = "end-of-line",
          ["alt-a"]  = "toggle-all",
          ["alt-s"]  = "toggle",
          -- ["ctrl-l"] = "clear-selection",
          ['ctrl-q'] = 'select-all+accept',
          -- Only valid with fzf previewers (bat/cat/git/etc)
          -- ["f3"]     = "toggle-preview-wrap",
          ["ctrl-i"] = "toggle-preview",
        },
      },
      actions  = {
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
      winopts    = {
        height = 0.7,
        width = 0.5,
        preview = {
          scrollbar = false,
          -- delay = 100,
          -- hidden = 'hidden',
          layout = 'vertical',
          vertical = 'up:55%',
        },
      },
      previewers = {
        codeaction = { toggle_behavior = 'extend' },
      },
      -- Configuration for specific commands.
      files      = {
        cwd_prompt = false,
        winopts = {
          preview = { hidden = true },
        },
      },
      git        = {
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
      lsp        = {
        cwd_only = true, -- LSP/diagnostics for cwd only?
        symbols = {
          symbol_icons = icons.kinds,
        },
        code_actions = {
          winopts = {
            width = 70,
            height = 20,
            relative = 'cursor',
            preview = {
              hidden = true,
              vertical = 'down:50%',
            },
          },
        },
      },
      oldfiles   = {
        cwd_only = true,
        include_current_session = true,
        winopts = {
          preview = { hidden = true },
        },
      },
      buffers    = {
        cwd_only = true,
        actions = {
          ["ctrl-x"] = actions.buf_split,
          ["ctrl-d"] = { fn = actions.buf_del, reload = true },
        }
      },
      manpages   = {
        cmd = "man -k -S 1 -M /usr/local/share/man .",
      },
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)
    -- require("fzf-lua").setup({ winopts = { row = 1, col = 0 } })
  end
}
