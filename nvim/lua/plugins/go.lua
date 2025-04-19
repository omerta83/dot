return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    -- branch = "develop"
    -- (optional) will update plugin's deps on every update
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
  },

  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {
      display_package = true,
    },
  }
}
