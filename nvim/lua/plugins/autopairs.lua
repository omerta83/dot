return {
  -- {
  --   'altermo/ultimate-autopair.nvim',
  --   event = { 'InsertEnter', 'CmdlineEnter' },
  --   branch = 'v0.6', --recommended as each new version will have breaking changes
  --   opts = {
  --     --Config goes here
  --     space2 = { enable = true },
  --     tabout = {
  --       enable = true,
  --       hopout = true,
  --       map = '<A-tab>',  --string or table
  --       cmap = '<A-tab>', --string or table
  --     },
  --     close = {
  --       map = '<A-)>',  --string or table
  --       cmap = '<A-)>', --string or table
  --     },
  --     fastwarp = {
  --       multi = true,
  --       { map = "<A-r>", rmap = "<A-R>", cmap = "<A-r>", rcmap = "<A-R>" },
  --       { faster = true, map = "<A-f>",  rmap = '<A-F>', cmap = "<A-f>", rcmap = '<A-F>' },
  --     },
  --     config_internal_pairs = {
  --       -- { '[', ']', suround = true },
  --       -- { '(', ')', suround = true },
  --       -- { '{', '}', suround = true },
  --       { '"', '"', dosuround = true },
  --       { "'", "'", dosuround = true },
  --     },
  --   },
  -- },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      local Rule = require 'nvim-autopairs.rule'
      local conds = require 'nvim-autopairs.conds'

      npairs.setup()

      -- Autoclosing angle-brackets.
      npairs.add_rule(Rule('<', '>', {
        -- Avoid conflicts with nvim-ts-autotag.
        '-html',
        '-javascriptreact',
        '-typescriptreact',
        '-vue',
      }):with_pair(
        -- regex will make it so that it will auto-pair on
        -- `a<` but not `a <`
        -- The `:?:?` part makes it also
        -- work on Rust generics like `some_func::<T>()`
        conds.before_regex('%a+:?:?$', 3)
      ):with_move(function(opts)
        return opts.char == '>'
      end))
    end,
  },
}
