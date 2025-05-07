vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.wo.linebreak = true
vim.wo.winbar = '' -- Turn off winbar

local o = vim.opt -- neovim style

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)
o.cursorline = true -- Enable highlighting of the current line

-- line break
o.linebreak = true -- Wrap long lines at a character in 'breakat'
o.breakindent = true -- indent wrapped lines
o.breakindentopt = { 'shift:2' }
-- o.breakindentopt = { 'shift:2', 'sbr' }
-- o.showbreak = '↪ '
o.formatoptions = "jcqln" -- do not wrap when format

o.inccommand = "nosplit" -- preview incremental substitute

o.list = true -- Show some invisible characters
o.listchars = { tab = '󰄾 ', trail = '·', eol = '¬' }

o.mouse = "a" -- Enable mouse mode
o.number = true -- Print line number
-- Completion.
o.wildignore:append { '.DS_Store' }
o.completeopt = 'menu,menuone,noselect'
o.pumblend = 0 -- Popup blend - 0 is fully opaque
o.pumheight = 15 -- Maximum number of entries in a popup

-- Indent
o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 2 -- Size of an indent
o.tabstop = 2 -- Number of spaces tabs count for
o.softtabstop = 2

o.shortmess:append { W = true, I = true, c = true, s = true }
o.ruler = false -- Display line and column when <C-g>

o.showmode = false -- Dont show mode since we have a statusline
o.signcolumn = "yes:2" -- Always show the signcolumn, otherwise it would shift the text each time
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically

-- Splitting
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.termguicolors = true -- True color support
o.undofile = true
o.undolevels = 10000
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.winblend = 0
o.wildoptions = 'pum' -- cmdline autocomplete menu
-- o.background = 'dark'
o.swapfile = false

o.hidden = true
-- vim.opt.numberwidth = 2
o.incsearch = true
-- opt.hlsearch = false
o.undolevels = 1500
o.autoindent = true

o.foldlevel = 99
o.foldlevelstart = 99
-- o.foldopen = 'hor'
-- opt.foldenable = true
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
o.fillchars:append { diff = "╱" }

-- statusline
o.laststatus = 3 -- global statusline
o.cmdheight = 1
o.showcmd = false

-- Update times and timeouts.
o.updatetime = 300
o.timeoutlen = 500
o.ttimeoutlen = 10

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.bo.swapfile = false

-- load vim plugins
vim.cmd([[
  packadd cfilter -- enable filter for quickfix
]])
