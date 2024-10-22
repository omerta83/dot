return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      {
        "<leader>cz",
        function()
          require("zen-mode").toggle()
        end,
        mode = "n",
        desc = "Zen Mode"
      }
    },
    opts = {
      window = {
        width = 0.50,
      },
      plugins = {
        kitty = {
          enabled = true,
          font = "+4",
        }
      }
    }
  }
}
