-- vim.cmd("autocmd!")

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.wo.linebreak = true
vim.wo.winbar = '' -- Turn off winbar

local opt = vim.opt
-- opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard + and *
opt.cursorline = true -- Enable highlighting of the current line
-- opt.formatoptions = "jcroqlnt" -- tcqj
opt.formatoptions = "jcqln" -- do not wrap when format
-- opt.grepformat = "%f:%l:%c:%m"
-- opt.grepprg = "rg --vimgrep --no-heading --smart-case"
-- opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.list = true -- Show some invisible characters
opt.listchars = "tab:󰄾 ,trail:·,eol:¬"
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
-- opt.scrolloff = 4 -- Lines of context
-- opt.sidescrolloff = 8 -- Columns of context
-- opt.shiftround = true -- Round indent

-- Indent
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for

opt.shortmess:append { W = true, I = true, c = true }
opt.showmode = false -- Dont show mode since we have a statusline
opt.signcolumn = "yes:2" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically

-- Splitting
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- True color support
-- opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.winblend = 0
opt.wildoptions = 'pum' -- cmdline autocomplete menu
opt.background = 'dark'
opt.swapfile = false

opt.hidden = true
-- vim.opt.numberwidth = 2
opt.incsearch = true
-- opt.hlsearch = false
opt.undolevels = 1500
opt.softtabstop = 2
opt.autoindent = true
opt.foldlevel = 99
opt.foldlevelstart = 99
-- opt.foldenable = true
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
opt.fillchars:append { diff = "╱" }

-- statusline
opt.laststatus = 3
opt.cmdheight = 0

-- Word wrap
-- opt.textwidth = 120
-- opt.wrapmargin = 0

-- Update times and timeouts.
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.bo.swapfile = false

-- load vim plugins
vim.cmd([[
  packadd cfilter
]])

-- local M = {}

-- function M.is_buffer_empty()
--   -- Check whether the current buffer is empty
--   return vim.fn.empty(vim.fn.expand("%:t")) == 1
-- end

-- function M.has_width_gt(cols)
--   -- Check if the windows width is greater than a given number of columns
--   return vim.fn.winwidth(0) / 2 > cols
-- end

-- return M
