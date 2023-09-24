local icons = require('config.icons')
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
        local utils = require("util")

        -- make sure forward function comes first
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
        local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
        -- stylua: ignore start
        utils.map({ "n", "x", "o" }, "]h", next_hunk_repeat, { desc = "Next Hunk" })
        utils.map({ "n", "x", "o" }, "[h", prev_hunk_repeat, { desc = "Prev Hunk" })
        utils.map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
        utils.map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
        utils.map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
        utils.map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        utils.map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
        utils.map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        utils.map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        utils.map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
        utils.map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
        utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
      end,
    },
  },

  -- {
  --   -- "TimUntersberger/neogit",
  --   'NeogitOrg/neogit',
  --   cmd = "Neogit",
  --   opts = {
  --     integrations = {
  --       diffview = true
  --     }
  --   }
  -- },
  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      providers = {
        'treesitter',
        -- 'lsp'
      },
      delay = 200,
      filetypes_denylist = {
        'dirvish',
        'fugitive',
        'NvimTree',
        'toggleterm',
        'TelescopePrompt',
        'DiffviewFiles',
        "lazy",
        "mason",
      }
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_create_autocmd("FileType", {
        -- reset ]] and [[
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
          pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
        end,
      })
    end,
    keys = {
      { "]]", function() require("illuminate").goto_next_reference() end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference() end, desc = "Prev Reference" },
    },
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
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
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
        -- close_fold_kinds = { "imports", "comment" },
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
      -- vim.keymap.set('n', '<CR>', 'za', { desc = "Toggle fold under cursor" })
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
          -- done = require('config.icons').misc.Check
        }
      })
    end
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      {
        "<leader>sr",
        function() require("spectre").open() end,
        desc =
        "Search and Replace in files (Spectre)"
      },
      {
        "<leader>sw",
        function() require("spectre").open_visual({ select_word = true }) end,
        desc =
        "Search and Replace in files using current word (Spectre)"
      },
      {
        "<leader>sw",
        function() require("spectre").open_visual() end,
        mode = "v",
        desc =
        "Search and Replace in files using current word (Spectre)"
      },
      {
        "<leader>sp",
        function() require("spectre").open_file_search({ select_word = true }) end,
        desc =
        "Search and Replace in current file (Spectre)"
      },
    },
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
