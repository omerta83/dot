return {
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = false,
    opts = {
      autocmds = {
        enableOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = true,
      },
      mappings = {
        enabled = true,
      }
    }
  }
}
