return {
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
