local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local home = os.getenv("HOME")
local cache = home .. "/.cache/nvim"
vim.opt.runtimepath:prepend(cache)

require("lazy").setup("plugins", {
  -- spec = {
  --   { import = "plugins" },
  -- },
  defaults = { lazy = true },
  install = {
    colorscheme = { "catppuccin" }
  },
  checker = {
    enabled = true,
    notify = false,
  },
  diff = {
    cmd = "terminal_git",
  },
  performance = {
    cache = {
      enabled = true,
      path = cache .. "/lazy/cache",
      disable_events = { "VimEnter", "BufReadPre" },
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  change_detection = {
    enabled = true,
    notify = false
  },
  debug = false,
})
