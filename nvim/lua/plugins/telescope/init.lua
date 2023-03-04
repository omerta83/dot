-- Fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  cmd = { "Telescope" },
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
    { 'barrett-ruth/telescope-http.nvim' },
    { 'mrjones2014/tldr.nvim' },
  },
  opts = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    local actions = require('telescope.actions')

    return {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--ignore",
          "--line-number",
          "--column",
          "--smart-case"
        },
        mappings = {
          n = {
              ["q"] = actions.close
          },
        },
        winblend = 0,
      },
      extensions = {
        live_grep_args = {
          auto_quoting = false,
          mappings = {
            i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob" })
            }
          }
        },
      },
    }
  end,
  keys = function()
    local status, _ = pcall(require, "telescope")
    if (not status) then return end
    local builtin = require("telescope.builtin")
    local telescope_git = require('plugins/telescope/git-commands')
    -- local function telescope_buffer_dir()
    --   return vim.fn.expand('%:p:h')
    -- end

    return {
      {
        "<Leader><space>",
        function()
          builtin.find_files({
            no_ignore = false,
            hidden = true
          })
        end,
        desc = "Find files (root dir)"
      },
      { "<Leader>fb", "<cmd>Telescope buffers<CR>",                       desc = "Buffers (Telescope)" },
      { "<Leader>fg", "<cmd>Telescope live_grep_args live_grep_args<CR>", desc = "Live Grep Args (Telescope)" },
      { "<Leader>fs", "<cmd>Telescope grep_string<CR>",                   desc = "Grep String (Telescope)" },
      { "<leader>fh", "<cmd>Telescope command_history<cr>",               desc = "Command History (Telescope)" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",                      desc = "Commands (Telescope)" },
      { "<leader>fr", "<cmd>Telescope http list<cr>",                     desc = "HTTP Status (Telescope)" },
      {
        "<Leader>fo",
        function()
          builtin.lsp_document_symbols({
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            }
          })
        end,
        desc = "Goto Symbol (Telescope)"
      },
      { '<Leader>ft', "<cmd>Telescope tldr<CR>",        desc = "tldr (Telescope)" },
      { '<Leader>f;', "<cmd>Telescope resume<CR>",      desc = "Resume (Telescope)" },
      { '<Leader>fd', "<cmd>Telescope diagnostics<CR>", desc = "Show Diagnostics (Telescope)" },
      -- Git
      -- { "<Leader>fv", "<cmd>Telescope git_commits<CR>",                   desc = "Git Commits (Telescope)" },
      {
        "<Leader>fvc",
        function ()
          telescope_git.git_commits()
        end,
        desc = "Git Commits (Telescope)",
      },
      {
        "<Leader>fvb",
        function ()
          telescope_git.git_bcommits()
        end,
        desc = "Git Buffer Commits (Telescope)",
      },
      {
        "<Leader>fvs",
        function ()
          telescope_git.git_status()
        end,
        desc = "Git Status (Telescope)"
      }
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)

    telescope.load_extension('fzf')
    telescope.load_extension('live_grep_args')
    telescope.load_extension('http')
    telescope.load_extension('tldr')
  end
}
