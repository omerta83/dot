return {
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recommended as each new version will have breaking changes
    opts = {
      --Config goes here
      space2 = { enable = true },
      tabout = {
        enable = true,
        hopout = true,
        map = '<A-tab>',  --string or table
        cmap = '<A-tab>', --string or table
      },
      close = {
        map = '<A-)>',  --string or table
        cmap = '<A-)>', --string or table
      },
      fastwarp = {
        multi = true,
        { map = "<A-r>", rmap = "<A-R>", cmap = "<A-r>", rcmap = "<A-R>" },
        { faster = true, map = "<A-f>",  rmap = '<A-F>', cmap = "<A-f>", rcmap = '<A-F>' },
      },
      config_internal_pairs = {
        -- { '[', ']', suround = true },
        -- { '(', ')', suround = true },
        -- { '{', '}', suround = true },
        { '"', '"', dosuround = true },
        { "'", "'", dosuround = true },
      },
    },
  },
}
