return {
  'windwp/nvim-autopairs',
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function ()
    require('nvim-autopairs').setup {}

    local cmp = require 'cmp'
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}

-- vim: ts=2 sts=2 sw=2 et

