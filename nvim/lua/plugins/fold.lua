return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    -- event = "BufReadPost",
    event = "VeryLazy",
    init = function()
      -- vim.o.fillchars = [[eob: ,fold:.,foldopen:-,foldsep: ,foldclose:+]]
      -- vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      -- https://github.com/kevinhwang91/nvim-ufo/issues/4
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:▏,foldclose:]]
      vim.o.statuscolumn = '%s%=%l %#FoldColumn#%{'
        .. 'foldlevel(v:lnum) > foldlevel(v:lnum - 1)'
        .. '? foldclosed(v:lnum) == -1'
        .. '? ""'
        .. ': ""'
        .. ': " "'
        .. '} '
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
        preview = {
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        },
        provider_selector = function()
          return { "treesitter", "indent" }
        end
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
      vim.keymap.set('n', ']z', ufo.goNextClosedFold, { desc = "Go to next closed fold" })
      vim.keymap.set('n', '[z', ufo.goPreviousClosedFold, { desc = "Go to previous closed fold" })
    end,
  },

  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- needed even when using default config
  },
}
