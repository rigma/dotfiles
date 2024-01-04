vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  config = function()
    local neotree = require 'neo-tree'

    neotree.setup {
      close_if_last_window = true,
      sources = {
        'document_symbols',
        'filesystem',
        'git_status',
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = 'filesystem' },
          { source = 'document_symbols' },
          { source = 'git_status' },
        }
      },
      document_symbols = {
        follow_cursor = true,
      },
      window = {
        mappings = {
          ["P"] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
        },
      },
    }

    vim.keymap.set('n', '\\', ':Neotree reveal git_base=HEAD<cr>', { desc = 'Neo[t]ree reveal', silent = true })
    vim.keymap.set('n', '<leader>\\g', ':Neotree source=git_status reveal=true git_base=HEAD<cr>',
      { desc = 'Neotree git status', silent = true })
    vim.keymap.set('n', '<leader>\\s', ':Neotree source=document_symbols reveal=true git_base=HEAD<cr>',
      { desc = 'Neotree document symbols', silent = true })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
