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

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = true },
  install = {
    missing = true,
    colorscheme = { "kanagawa-dragon" }
  },
  ui = {
    border = "single",
    backdrop = 100
  },
  diff = {
    cmd = "terminal_git",
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      paths = {
        "/usr/local/opt/fzf",    -- homebrew version of fzf for Intel Macs
        "/opt/homebrew/opt/fzf", -- homebrew version of fzf for Apple Silicon Macs
      },
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
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
  rocks = {
    enabled = false,
  },
  debug = false,
})
