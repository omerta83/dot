return {
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      autocmds = {
        enableOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = true,
      },
      mappings = {
        enabled = false,
      }
    }
  }
}
