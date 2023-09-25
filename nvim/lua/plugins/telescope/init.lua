-- Fuzzy finder
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    version = false,
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      -- { 'barrett-ruth/telescope-http.nvim' },
      -- { 'mrjones2014/tldr.nvim' },
    },
    opts = function()
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      return {
        defaults = {
          mappings = {
            n = {
              ["q"] = function()
                return require('telescope.actions').close()
              end,
              ["s"] = flash
            },
            i = {
              ["<c-s>"] = flash,
              ["<c-q>"] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
            }
          },
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
          file_ignore_patterns = { "node_modules", ".git" },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = false,
            mappings = {
              i = {
                ["<C-k>"] = require('telescope-live-grep-args.actions').quote_prompt(),
              }
            }
          },
        },
      }
    end,
    keys = {
      {
        "<Leader><space>",
        function()
          require('telescope.builtin').find_files({
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
      -- { "<leader>ff", "<cmd>Telescope flutter commands<cr>",              desc = "Flutter Commands" },
      {
        "<Leader>fo",
        function()
          require('telescope.builtin').lsp_document_symbols({
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
      -- { '<Leader>ft', "<cmd>Telescope tldr<CR>",        desc = "tldr (Telescope)" },
      { '<Leader>f;', "<cmd>Telescope resume<CR>",      desc = "Resume (Telescope)" },
      { '<Leader>fd', "<cmd>Telescope diagnostics<CR>", desc = "Show Diagnostics (Telescope)" },
      -- Git
      {
        "<Leader>fvc",
        function()
          require('plugins.telescope.git-commands').git_commits()
        end,
        desc = "Git Commits (Telescope)",
      },
      {
        "<Leader>fvb",
        function()
          require('plugins.telescope.git-commands').git_bcommits()
        end,
        desc = "Git Buffer Commits (Telescope)",
      },
      {
        "<Leader>fvs",
        function()
          require('plugins.telescope.git-commands').git_status()
        end,
        desc = "Git Status (Telescope)"
      }
    },
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)

      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
      -- telescope.load_extension('http')
      -- telescope.load_extension('tldr')
      -- telescope.load_extension('flutter')
    end
  }
}
